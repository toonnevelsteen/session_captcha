# encoding: utf-8
require 'rails'
require 'session_captcha'

module SessionCaptcha
  class Railtie < ::Rails::Engine
    config.before_initialize do
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send(:include, SessionCaptcha::ModelHelpers)
      end
    end
    
    config.after_initialize do
      ActionView::Base.send(:include, SessionCaptcha::ViewHelper)
      ActionView::Helpers::FormBuilder.send(:include, SessionCaptcha::FormBuilder)
      
      if Object.const_defined?("Formtastic")
        Formtastic::SemanticFormHelper.builder = SessionCaptcha::CustomFormBuilder
      end
    end
  end
end


