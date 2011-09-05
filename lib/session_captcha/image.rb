module SessionCaptcha #:nodoc
  module ImageHelpers #:nodoc

    mattr_accessor :image_styles
    @@image_styles = {
      'embosed_silver'  => ['-fill darkblue', '-shade 20x60', '-background white'],
      'simply_red'      => ['-fill darkred', '-background white'],
      'simply_green'    => ['-fill darkgreen', '-background white'],
      'simply_blue'     => ['-fill darkblue', '-background white'],
      'distorted_black' => ['-fill darkblue', '-edge 10', '-background white'],
      'all_black'       => ['-fill darkblue', '-edge 2', '-background white'],
      'charcoal_grey'   => ['-fill darkblue', '-charcoal 5', '-background white'],
      'almost_invisible' => ['-fill red', '-solarize 50', '-background white']
    }

    DISTORTIONS = ['low', 'medium', 'high']

    class << self

      def image_params(key = 'simply_blue')
        image_keys = @@image_styles.keys

        style = begin
          if key == 'random'
            image_keys[rand(image_keys.length)]
          else
            image_keys.include?(key) ? key : 'simply_blue'
          end
        end

        @@image_styles[style]
      end

      def distortion(key='low')
        key =
          key == 'random' ?
          DISTORTIONS[rand(DISTORTIONS.length)] :
          DISTORTIONS.include?(key) ? key : 'low'
        case key.to_s
          when 'low' then return [0 + rand(2), 80 + rand(20)]
          when 'medium' then return [2 + rand(2), 50 + rand(20)]
          when 'high' then return [4 + rand(2), 30 + rand(20)]
        end
      end
    end

    if RUBY_VERSION < '1.9'
      class Tempfile < ::Tempfile
        # Replaces Tempfile's +make_tmpname+ with one that honors file extensions.
        def make_tmpname(basename, n = 0)
          extension = File.extname(basename)
          sprintf("%s,%d,%d%s", File.basename(basename, extension), $$, n, extension)
        end
      end
    end

    private

      def generate_session_captcha_image(session_captcha_key) #:nodoc
        amplitude, frequency = ImageHelpers.distortion(SessionCaptcha.distortion)
        text = Utils::session_captcha_value(session_captcha_key)

        params = ImageHelpers.image_params(SessionCaptcha.image_style).dup
        params << "-size #{SessionCaptcha.image_size}"
        params << "-wave #{amplitude}x#{frequency}"
        params << "-gravity 'Center'"
        params << "-pointsize 22"
        params << "-implode 0.2"

        dst = RUBY_VERSION < '1.9' ? Tempfile.new('session_captcha.jpg') : Tempfile.new(['session_captcha', '.jpg'])
        dst.binmode

        params << "label:#{text} '#{File.expand_path(dst.path)}'"

        SessionCaptcha::Utils::run("convert", params.join(' '))

        dst.close

        File.expand_path(dst.path)
      end
  end
end
