require "tinymce/rails/asset_manifest"

module TinyMCE
  module Rails
    describe PropshaftManifest do
      subject(:manifest) { PropshaftManifest.new(fixture("propshaft_manifest/.manifest.json")) }

      def reload_manifest(manifest)
        JSON.parse(manifest.to_s)
      end

      it "keeps existing manifest data" do
        result = reload_manifest(manifest)
        expect(result["application.css"]).to eq("application-c2cd8c57.css")
        expect(result["application.js"]).to eq("application-bfcdf840.js")
        expect(result["tinymce/tinymce.js"]).to eq("tinymce/tinymce-52aa7906.js")
      end

      describe "#append" do
        let(:file) { double }

        it "adds files to the manifest without a fingerprint" do
          manifest.append("tinymce/tinymce.js", file)

          result = reload_manifest(manifest)
          expect(result["tinymce/tinymce.js"]).to eq("tinymce/tinymce.js")
        end
      end

      describe "#remove" do
        it "removes files from the manifest" do
          manifest.remove("tinymce/tinymce.js")

          result = reload_manifest(manifest)
          expect(result).to_not have_key("tinymce/tinymce.js")
        end
      end

      describe "#remove_digest" do
        it "sets the file digest value to its non-digested version" do
          manifest.remove_digest("tinymce/tinymce.js")

          result = reload_manifest(manifest)
          expect(result["tinymce/tinymce.js"]).to eq("tinymce/tinymce.js")
        end

        it "yields the digested and non-digested file names" do
          expect { |block|
            manifest.remove_digest("tinymce/tinymce.js", &block)
          }.to yield_with_args("tinymce/tinymce-52aa7906.js", "tinymce/tinymce.js")
        end
      end

      describe "#each" do
        it "yields the logical path for each asset that matches the given pattern" do
          result = []
          manifest.each(/^tinymce/) { |asset| result << asset }
          expect(result).to eq(["tinymce/tinymce.js"])
        end
      end

      describe ".try" do
        it "returns a new JsonManifest if a JSON manifest exists for the given path" do
          manifest = PropshaftManifest.try(fixture("propshaft_manifest"))
          expect(manifest).to be_an_instance_of(PropshaftManifest)
        end

        it "returns nil if no JSON manifest was found" do
          expect(PropshaftManifest.try(fixture("no_manifest"))).to be_nil
        end
      end
    end
  end
end
