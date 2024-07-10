require "tinymce/rails/asset_manifest"

module TinyMCE
  module Rails
    describe JsonManifest do
      subject(:manifest) { JsonManifest.new(fixture("json_manifest/.sprockets-manifest-18802ea98f713a419dac90694dd5b6c4.json")) }

      def reload_manifest(manifest)
        JSON.parse(manifest.to_s)
      end

      it "keeps existing manifest data" do
        result = reload_manifest(manifest)
        expect(result["assets"]["application.js"]).to eq("application-cd171d98b53f649551a409c3b5f65272.js")
        expect(result["files"]["application-cd171d98b53f649551a409c3b5f65272.js"]).to eq({
          "logical_path" => "application.js",
          "mtime" => "2013-02-11T11:26:00+10:30",
          "size" => 579,
          "digest" => "cd171d98b53f649551a409c3b5f65272"
        })
      end

      describe "#append" do
        let(:file) { double }
        let(:mtime) { double(:iso8601 => "2013-02-26T12:29:33+10:30") }

        it "adds files to the manifest without a fingerprint" do
          expect(File).to receive(:stat).with(file).and_return(double(:mtime => mtime, :size => 123))

          manifest.append("tinymce/tiny_mce_jquery.js", file)

          result = reload_manifest(manifest)
          expect(result["assets"]["tinymce/tiny_mce_jquery.js"]).to eq("tinymce/tiny_mce_jquery.js")
          expect(result["files"]["tinymce/tiny_mce_jquery.js"]).to eq({
            "logical_path" => "tinymce/tiny_mce_jquery.js",
            "mtime" => "2013-02-26T12:29:33+10:30",
            "size" => 123,
            "digest" => nil
          })
        end
      end

      describe "#remove" do
        it "removes files from the manifest" do
          manifest.remove("tinymce.js")

          result = reload_manifest(manifest)
          expect(result["assets"]).to_not have_key("tinymce.js")
          expect(result["files"]).to_not have_key("tinymce-89aa452594633dfb3487381efbe9706e.js")
        end
      end

      describe "#remove_digest" do
        it "sets the file digest value to its non-digested version" do
          manifest.remove_digest("tinymce.js")

          result = reload_manifest(manifest)
          expect(result["assets"]["tinymce.js"]).to eq("tinymce.js")
          expect(result["files"]).to_not have_key("tinymce-89aa452594633dfb3487381efbe9706e.js")
          expect(result["files"]["tinymce.js"]).to eq({
            "logical_path" => "tinymce.js",
            "mtime" => "2013-02-12T20:57:55+10:30",
            "size" => 521386,
            "digest" => nil
          })
        end

        it "yields the digested and non-digested file names" do
          expect { |block|
            manifest.remove_digest("tinymce.js", &block)
          }.to yield_with_args("tinymce-89aa452594633dfb3487381efbe9706e.js", "tinymce.js")
        end
      end

      describe "#each" do
        it "yields the logical path for each asset that matches the given pattern" do
          result = []
          manifest.each(/^tinymce/) { |asset| result << asset }
          expect(result).to eq(["tinymce.js"])
        end
      end

      describe ".try" do
        it "returns a new JsonManifest if a JSON manifest exists for the given path" do
          manifest = JsonManifest.try(fixture("json_manifest"), ".sprockets-manifest*.json")
          expect(manifest).to be_an_instance_of(JsonManifest)
        end

        it "returns nil if no JSON manifest was found" do
          expect(JsonManifest.try(fixture("no_manifest"), ".sprockets-manifest*.json")).to be_nil
        end
      end
    end
  end
end
