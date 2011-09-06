module SessionCaptcha #:nodoc
  module ViewHelper #:nodoc

    # Simple Captcha is a very simplified captcha.
    #
    # *show_session_captcha* method will return the image, the label and the text box.
    # This method should be called from the view within your form as...
    #
    # <%= show_session_captcha generate_captcha_url %>
    #
    # <b>Label:</b>
    #
    # default label is "type the text from the image", it can be modified by passing :label as
    #
    # <%= show_session_captcha(generate_captcha_url, :label => "new captcha label") %>.
    def show_session_captcha(url, *args)
      options = args.extract_options!

      defaults = {
         :image => session_captcha_image(url),
         :label => options[:label] || I18n.t('session_captcha.label'),
         :field => session_captcha_field(options)
         }
         
      render :partial => 'session_captcha/session_captcha', :locals => { :session_captcha_options => defaults }
    end

    private

      def session_captcha_image(url)
        "<img src='#{url}' alt='captcha' />".html_safe
      end
      
      def session_captcha_field(options={})
        if options[:object]
          text_field(options[:object], :captcha, :value => '', :autocomplete => 'off') +
          hidden_field(options[:object], :captcha_key, {:value => options[:field_value]})
        else
          text_field_tag(:captcha, nil, :autocomplete => 'off')
        end
      end

      def set_session_captcha_data(key, options={})
        code_type = options[:code_type]
        
        value = generate_session_captcha_data(code_type)
        data = SessionCaptcha::SessionCaptchaData.get_data(key)
        data.value = value
        data.save
        key
      end
   
      def generate_session_captcha_data(code)
        value = ''
        
        case code
          when 'numeric' then 
            SessionCaptcha.length.times{value << (48 + rand(10)).chr}
          else
            SessionCaptcha.length.times{value << (65 + rand(26)).chr}
        end
        
        return value
      end
      
      def session_captcha_key(key_name = nil)
        if key_name.nil?
          session[:captcha] ||= SessionCaptcha::Utils.generate_key(session[:id].to_s, 'captcha')
        else
          SessionCaptcha::Utils.generate_key(session[:id].to_s, key_name)
        end
      end 
  end
end
