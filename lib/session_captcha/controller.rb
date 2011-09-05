module SessionCaptcha #:nodoc
  module ControllerHelpers #:nodoc
    # This method is to validate the simple captcha in controller.
    # It means when the captcha is controller based i.e. :object has not been passed to the method show_session_captcha.
    #
    # *Example*
    #
    # If you want to save an object say @user only if the captcha is validated then do like this in action...
    #
    #  if session_captcha_valid?
    #   @user.save
    #  else
    #   flash[:notice] = "captcha did not match"
    #   redirect_to :action => "myaction"
    #  end
    def session_captcha_valid?
      return true if Rails.env.test?
      
      if params[:captcha]
        data = SessionCaptcha::Utils::session_captcha_value(session[:captcha])
        result = data == params[:captcha].delete(" ").upcase
        SessionCaptcha::Utils::session_captcha_passed!(session[:captcha]) if result
        return result
      else
        return false
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
