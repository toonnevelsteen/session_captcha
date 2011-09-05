module SessionCaptcha
  class CustomFormBuilder < Formtastic::SemanticFormBuilder

    private

    def session_captcha_input(method, options)
      options.update :object => sanitized_object_name
      self.send(:show_session_captcha, options)
    end
  end
end
