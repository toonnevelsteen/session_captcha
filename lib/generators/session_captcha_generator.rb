require 'rails/generators'

class SessionCaptchaGenerator < Rails::Generators::Base
  def self.source_root
    @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates/'))
  end

  desc "This generator creates an initializer file at config/initializers"
  def create_initializer_file
    copy_file "session_captcha.rb", "config/initializers/session_captcha.rb"
    append_to_file "config/initializers/session_captcha.rb" do
      "Rails.application.config.session_captcha_salt = '#{ActiveSupport::SecureRandom.hex(64)}'"
    end
  end

  def create_partial
    template "partial.erb", File.join('app/views', 'session_captcha', "_session_captcha.erb")
  end
end
