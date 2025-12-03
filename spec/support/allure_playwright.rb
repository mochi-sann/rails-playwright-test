require "allure-rspec"
require "fileutils"
require "tempfile"

RSpec.configure do |config|
  config.before(:each, type: :system) do |example|
    next unless ENV["PLAYWRIGHT_RECORD"] == "1"

    driver = Capybara.current_session&.driver
    next unless driver.respond_to?(:on_save_screenrecord)

    driver.on_save_screenrecord do |video_path|
      next unless video_path && File.file?(video_path)

      Allure.add_attachment(
        name: "screenrecord - #{example.full_description}",
        source: File.binread(video_path),
        type: Allure::ContentType::WEBM,
        test_case: true
      )
    end
  end

  config.after(:each, type: :system) do |example|
    next unless example.exception

    attach_playwright_screenshot(example)
    attach_console_logs(example)
  end
end

def attach_playwright_screenshot(example)
  file = nil
  session = Capybara.current_session
  return unless session&.respond_to?(:save_screenshot)

  file = Tempfile.new(["playwright", ".png"])
  session.save_screenshot(file.path)

  Allure.add_attachment(
    name: "screenshot - #{example.full_description}",
    source: File.binread(file.path),
    type: Allure::ContentType::PNG,
    test_case: true
  )
rescue StandardError
  # Ignore capture errors when the driver/session cannot be created
ensure
  file&.close!
  file&.unlink
end

def attach_console_logs(example)
  logs = Capybara.current_session&.evaluate_script("window.__playwrightConsole || []")
rescue StandardError
  logs = []
ensure
  if logs.present?
    Allure.add_attachment(
      name: "console-log - #{example.full_description}",
      source: logs.join("\n"),
      type: Allure::ContentType::TXT,
      test_case: true
    )
  end
end
