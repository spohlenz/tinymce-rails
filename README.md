Rails 3.1 Integration for TinyMCE
=================================

This is a proof of concept for integrating TinyMCE with the Rails 3.1 asset pipeline.

For correct operation in production mode, it currently requires the `spohlenz/fingerprinting` branches of Sprockets and Rails, which are located at:

* https://github.com/spohlenz/rails/tree/fingerprinting
* https://github.com/spohlenz/sprockets/tree/fingerprinting

The intent of this repository is to convey why the feature implemented in these branches should be incorporated.

See https://github.com/rails/rails/issues/2294 for a description of this issue.


Instructions
------------

**1. Add sources to Gemfile**

If and when the branches are merged into mainline Rails/Sprockets, the only step required here is to add `gem 'jquery-rails'` to the Gemfile.

    source 'http://rubygems.org'
    
    gem 'rails', :git => 'git://github.com/spohlenz/rails.git', :branch => "fingerprinting"
    gem 'sprockets', :git => 'git://github.com/spohlenz/sprockets.git', :branch => "fingerprinting"
    
    gem 'tinymce-rails', :path => "git://github.com/spohlenz/tinymce-rails"
    
    # Gems used only for assets and not required
    # in production environments by default.
    group :assets do
      gem 'sass-rails', :git => "git://github.com/rails/sass-rails.git"
      gem 'coffee-rails', :git => "git://github.com/rails/coffee-rails.git"
      gem 'uglifier'
    end
    
    gem 'jquery-rails'

Run `bundle install` after updating.


**2. Edit `config/environments/production.rb`**

Need to disable compression (due to an encoding issue - hopefully this can be fixed) and enable fingerprinting.

    # Compress JavaScripts and CSS
    config.assets.compress = false

    # Append fingerprints to asset filenames
    config.assets.fingerprinting.enabled = true

As with Step 1, this won't be necessary after the fingerprinting configuration options are incorporated.


**3a. Add TinyMCE with jQuery extension**

Add to your application.js:

    //= require tiny_mce.jquery

Use TinyMCE in your view:

    <%= text_area_tag :editor, "", :rows => 40, :cols => 120 %>

    <script type="text/javascript">
      $(function() {
        $('#editor').tinymce({
          theme: 'advanced'
        });
      });
    </script>


**3b. Add TinyMCE without jQuery**

Add to your application.js:

    //= require tiny_mce

Use TinyMCE in your view:

    <%= text_area_tag :editor, "", :rows => 40, :cols => 120 %>

    <script type="text/javascript">
      tinyMCE.init({
        mode: 'textareas',
        theme: 'advanced'
      });
    </script>


Benefits
--------

This gem neatly integrates TinyMCE into the asset pipeline, inheriting all of the benefits that this brings including asset compression/minification (once the encoding issues are sorted) and asset concatenation.

It keeps the TinyMCE files nicely tucked away, whilst still allowing custom plugins - as long as your custom plugin is located at `tiny_mce/plugins/plugin_name` within any asset load path.

It also removes the need for an additional rake task to install the TinyMCE assets into `public/`. `rake assets:compile` will copy all of the required assets into `public/assets/` for production deployments. This has the added benefit of making it incredibly easy to update to a newer version of the tinymce-rails gem simply by running `bundle update tinymce-rails`.
