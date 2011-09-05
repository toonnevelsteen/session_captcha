module SessionCaptcha
  module FormBuilder
    def self.included(base)
      base.send(:include, SessionCaptcha::ViewHelper)
      base.send(:include, SessionCaptcha::FormBuilder::ClassMethods)
      
      base.delegate :render, :session, :to => :template
    end
    
    module ClassMethods
      # Example:
		  # <% form_for :post, :url => posts_path do |form| %>
		  #   ...
		  #   <%= form.session_captcha :label => "Enter numbers.." %>
		  # <% end %>
		  #
		  def session_captcha(options = {})
      	options.update :object => @object_name
      	show_session_captcha(objectify_options(options))
      end
      
      private
        
        def template
          @template
        end
        
        def session_captcha_field(options={})
          text_field(:captcha, :value => '', :autocomplete => 'off') +
          hidden_field(:captcha_key, {:value => options[:field_value]})
        end
    end
  end
end
