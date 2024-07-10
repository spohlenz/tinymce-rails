module TinyMCE
  module Rails
    class AssetManifest
      attr_reader :file

      def self.load(manifest_path)
        PropshaftManifest.try(manifest_path) ||
          JsonManifest.try(manifest_path, ".sprockets-manifest*.json") ||
          JsonManifest.try(manifest_path, "manifest*.json") ||
          JsonManifest.try(manifest_path) ||
          YamlManifest.try(manifest_path) ||
          NullManifest.new
      end

      def each(pattern)
        assets.each_key do |asset|
          if asset =~ pattern && !index_asset?(asset)
            yield asset
          end
        end
      end

      def asset_path(logical_path)
        if digested = assets[logical_path]
          yield digested, logical_path if block_given?
        end
      end

      def to_s
        dump
      end

    protected
      def index_asset?(asset)
        asset =~ /\/index[^\/]*\.\w+$/
      end
    end

    require_relative "asset_manifest/json_manifest"
    require_relative "asset_manifest/null_manifest"
    require_relative "asset_manifest/propshaft_manifest"
    require_relative "asset_manifest/yaml_manifest"
  end
end
