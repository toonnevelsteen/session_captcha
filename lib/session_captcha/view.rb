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
  end
end
