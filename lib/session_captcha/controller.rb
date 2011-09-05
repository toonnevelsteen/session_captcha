module SessionCaptcha #:nodoc
  module ControllerHelpers #:nodoc
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
    end

    private

    def set_session_captcha_data(hashed_value)
      session[:captcha] = hashed_value
    end
  end
end
