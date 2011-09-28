require "sprockets/asset"
module Sprockets
  class Asset
    def digest_path
      return logical_path if logical_path =~ /^tinymce\//
      environment.attributes_for(logical_path).path_with_fingerprint(digest)
    end
  end
end

