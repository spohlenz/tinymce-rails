require "tinymce/rails/asset_manifest"

module TinyMCE
  module Rails
    describe NullManifest do
      subject { NullManifest.new }

      it { should respond_to(:append) }
      it { should respond_to(:remove) }
      it { should respond_to(:remove_digest) }
      it { should respond_to(:each) }
      it { should respond_to(:write) }
    end
  end
end
