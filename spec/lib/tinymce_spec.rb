require 'spec_helper'

describe TinyMCE do
  it "has a base path" do
    TinyMCE.base.should eq("/assets/tinymce")
  end
end
