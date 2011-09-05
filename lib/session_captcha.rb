# encoding: utf-8

module SessionCaptcha
  autoload :Utils,             'session_captcha/utils'

  autoload :ImageHelpers,      'session_captcha/image'
  autoload :ViewHelper,        'session_captcha/view'
  autoload :ControllerHelpers, 'session_captcha/controller'
  autoload :ModelHelpers,      'session_captcha/active_record'

  autoload :FormBuilder,       'session_captcha/form_builder'
  autoload :CustomFormBuilder, 'session_captcha/formtastic'

  autoload :SessionCaptchaData, 'session_captcha/session_captcha_data'

  mattr_accessor :image_size
  @@image_size = "100x28"

  mattr_accessor :length
  @@length = 5

  # 'embosed_silver',
  # 'simply_red',
  # 'simply_green',
  # 'simply_blue',
  # 'distorted_black',
  # 'all_black',
  # 'charcoal_grey',
  # 'almost_invisible'
  # 'random'
  mattr_accessor :image_style
  @@image_style = 'simply_blue'

  # 'low', 'medium', 'high', 'random'
  mattr_accessor :distortion
  @@distortion = 'low'

  # command path
  mattr_accessor :image_magick_path
  @@image_magick_path = ''

  def self.add_image_style(name, params = [])
    SessionCaptcha::ImageHelpers.image_styles.update(name.to_s => params)
  end

  def self.setup
    yield self
  end
end

require 'session_captcha/railtie'
