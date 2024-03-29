require 'digest/sha1'

module SessionCaptcha #:nodoc
  module Utils #:nodoc
    # Execute command with params and return output if exit status equal expected_outcodes
    def self.run(cmd, params = "", expected_outcodes = 0)
      command = %Q[#{cmd} #{params}].gsub(/\s+/, " ")
      command = "#{command} 2>&1"

      unless (image_magick_path = SessionCaptcha.image_magick_path).blank?
        command = File.join(image_magick_path, command)
      end

      output = `#{command}`

      unless [expected_outcodes].flatten.include?($?.exitstatus)
        raise ::StandardError, "Error while running #{cmd}: #{output}"
      end

      output
    end

    def self.generate_key(*args)
      args << Rails.application.config.session_captcha_salt
      Digest::SHA1.hexdigest(args.join)
    end

    def self.generate_session_captcha_data(code='alfanumeric')
      value = ""

      if code.to_s == 'alfanumeric'
        SessionCaptcha.length.times{value << (65 + rand(26)).chr}
      else
        # 'numeric'
        SessionCaptcha.length.times{value << (48 + rand(10)).chr}
      end

      value
    end
  end
end
