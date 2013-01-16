require 'spec_helper'

module TinyMCE::Rails
  describe Engine do
    describe ".default_base" do

      specify {TinyMCE::Rails::Engine.default_base.should eql "/assets/tinymce"}

      it "should include relative_url_root" do
        Rails.application.config.stub!(:relative_url_root).and_return "/prefix"
        TinyMCE::Rails::Engine.default_base.should eql "/prefix/assets/tinymce"
      end

      it "should be only /tinymce if no parameter is given" do
        Rails.application.config.assets.stub!(:prefix).and_return nil
        TinyMCE::Rails::Engine.default_base.should eql "/tinymce"
      end
      it "should be relative_url_root and /tinymce if no prefix parameter is given" do
        Rails.application.config.stub!(:relative_url_root).and_return "/prefix"
        Rails.application.config.assets.stub!(:prefix).and_return nil
        TinyMCE::Rails::Engine.default_base.should eql "/prefix/tinymce"
      end
    end
  end
end
