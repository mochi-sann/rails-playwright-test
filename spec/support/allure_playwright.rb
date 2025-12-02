require "allure-rspec"
require "fileutils"

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
end
