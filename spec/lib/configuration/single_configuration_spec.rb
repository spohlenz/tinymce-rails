require 'spec_helper'

module TinyMCE::Rails
  describe SingleConfiguration do
    it "has default options" do
      SingleConfiguration.defaults.should eq(
        "mode"            => "specific_textareas",
        "theme"           => "advanced",
        "editor_selector" => "tinymce"
      )
    end
  end
end

