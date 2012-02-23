module TinyMCE
  module Rails

    class Railtie < ::Rails::Railtie

      rake_tasks do
        load File.join(File.dirname(__FILE__), 'assets.rake')
      end

    end

  end
end
