module TinyMCE
  module Rails
    class NullManifest < AssetManifest
      def append(*); end
      def remove(*); end
      def remove_digest(*); end
      def assets; {}; end
      def each(*); end
      def write; end
    end
  end
end
