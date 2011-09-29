module SessionCaptcha #:nodoc
  module ControllerHelpers #:nodoc

    def self.included(c)
      c.class_eval do
        include ActionController::Streaming
        include SessionCaptcha::ImageHelpers
      end
    end
    

    def session_captcha_valid?
      return true if Rails.env.test?
      
      if params[:captcha]
        hashed_value = SessionCaptcha::Utils::generate_key( session[:session_id], params[:captcha].delete(" ").upcase )
        session[:captcha] == hashed_value
      else
        false
      end
    end

    def generate_captcha
      value = SessionCaptcha::Utils::generate_session_captcha_data('alfanumeric')
      hashed_value = SessionCaptcha::Utils::generate_key(session[:session_id], value)

      set_session_captcha_data(hashed_value)

      begin
        filename = generate_session_captcha_image(value)
        File.open(filename, 'r') do |f|
          send_data (f.read, :type => 'image/jpeg', :disposition => 'inline', :filename => 'session_captcha.jpg' )
        end
      ensure
        File.unlink(filename) if filename
      end
    end

    private

    def set_session_captcha_data(hashed_value)
      session[:captcha] = hashed_value
    end
  end
end
