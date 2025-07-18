require "tinymce/rails/asset_manifest"

module TinyMCE
  module Rails
    describe AssetManifest do
      describe ".load" do
        it "returns a NewPropshaftManifest if a new Propshaft manifest file exists within the given path", if: defined?(Propshaft::Manifest) do
          manifest = AssetManifest.load(fixture("new_propshaft_manifest"))
          expect(manifest).to be_an_instance_of(NewPropshaftManifest)
          expect(manifest.file).to eq fixture("new_propshaft_manifest/.manifest.json")
        end

        it "returns a PropshaftManifest if a Propshaft manifest file exists within the given path", if: !defined?(Propshaft::Manifest) do
          manifest = AssetManifest.load(fixture("propshaft_manifest"))
          expect(manifest).to be_an_instance_of(PropshaftManifest)
          expect(manifest.file).to eq fixture("propshaft_manifest/.manifest.json")
        end

        it "returns a YamlManifest if a YAML manifest file exists within the given path" do
          manifest = AssetManifest.load(fixture("yaml_manifest"))
          expect(manifest).to be_an_instance_of(YamlManifest)
          expect(manifest.file).to eq fixture("yaml_manifest/manifest.yml")
        end

        it "returns a JsonManifest if a JSON manifest file exists within the given path" do
          manifest = AssetManifest.load(fixture("json_manifest"))
          expect(manifest).to be_an_instance_of(JsonManifest)
          expect(manifest.file).to eq fixture("json_manifest/.sprockets-manifest-18802ea98f713a419dac90694dd5b6c4.json")
        end

        it "returns a JsonManifest if a specific JSON manifest file is provided" do
          manifest = AssetManifest.load(fixture("json_manifest.json"))
          expect(manifest).to be_an_instance_of(JsonManifest)
          expect(manifest.file).to eq fixture("json_manifest.json")
        end

        it "returns a JsonManifest if a legacy JSON manifest file exists within the given path" do
          manifest = AssetManifest.load(fixture("legacy_manifest"))
          expect(manifest).to be_an_instance_of(JsonManifest)
          expect(manifest.file).to eq fixture("legacy_manifest/manifest-18802ea98f713a419dac90694dd5b6c4.json")
        end

        it "returns a NullManifest if it can't find a manifest" do
          manifest = AssetManifest.load(fixture("no_manifest"))
          expect(manifest).to be_an_instance_of(NullManifest)
        end
      end
    end
  end
end
