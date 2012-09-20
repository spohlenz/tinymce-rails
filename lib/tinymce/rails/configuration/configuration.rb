module TinyMCE::Rails
  class Configuration
    class << self

      def load(data)
        config = read_config(data)
        multiple?(config) ? MultipleConfiguration.new(config) : SingleConfiguration.new(config)
      end

      private

      def read_config(data)
        if data.is_a? String
          read_yaml(data) if File.exists?(data)
        elsif data.is_a? Hash
          data
        end
      end

      def read_yaml(filename)
        YAML::load(ERB.new(IO.read(filename)).result)
      end

      def multiple?(config)
        config && config.values.map(&:class).uniq.first == Hash
      end

    end
  end
end
