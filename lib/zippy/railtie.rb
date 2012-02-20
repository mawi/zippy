require 'zippy'
require 'rails'

class ZippyRailtie < Rails::Railtie
  railtie_name :zippy

  initializer "zippy_railtie" do
    Mime::Type.register 'application/zip', :zip

    module ::ActionView
      module Template::Handlers
        class Zipper
          def self.call(template)
            new.compile(template)
          end

          def compile(template)
            "Zippy.new { |zip| #{(template.respond_to?(:source) ? template.source : template)} }.data"
          end
        end
      end
      Template.register_template_handler :zipper, Template::Handlers::Zipper
    end
  end
end
