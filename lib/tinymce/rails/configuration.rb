module TinyMCE::Rails
  class Configuration
    def self.defaults
      {
        "mode"            => "textareas",
        "theme"           => "advanced",
        "language"        => default_language,
        "editor_selector" => "tinymce"
      }
    end
    
    attr_reader :options
    
    def initialize
      @options = self.class.defaults
    end
    
    # Default language falls back to English if current locale is not available.
    def self.default_language
      available_languages.include?(I18n.locale.to_s) ? I18n.locale.to_s : "en"
    end
    
    # Searches asset paths for TinyMCE language files.
    def self.available_languages
      assets.paths.map { |path|
        files = assets.entries(File.join(path, "tinymce/langs"))
        files.map { |file|
          asset = assets.attributes_for(File.join(path, file))
          asset.logical_path.sub(/\.js$/, "")
        }
      }.flatten.uniq
    end
  
    def self.assets
      Rails.application.assets
    end
  end
end
