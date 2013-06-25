Rails Integration for TinyMCE
=============================

The `tinymce-rails` gem integrates the [TinyMCE](http://www.tinymce.com/) editor with the Rails asset pipeline.

This gem is compatible with Rails 3.1.1 and higher (including Rails 4).

This is the branch for TinyMCE 4. TinyMCE 3.5.x is currently available in the [master branch](https://github.com/spohlenz/tinymce-rails). For the time being, parallel versions of TinyMCE (3.5.x and 4.x) will be maintained. However TinyMCE 4 will eventually be promoted to the master branch.

[![Build Status](https://travis-ci.org/spohlenz/tinymce-rails.png?branch=tinymce-4)](https://travis-ci.org/spohlenz/tinymce-rails)


Instructions
------------

**1. Add `tinymce-rails` to your Gemfile**

    gem 'tinymce-rails'

Be sure to add to the global group, not the `assets` group. Then run `bundle install`.


**2. Create a `config/tinymce.yml` file with your global configuration options:**

    toolbar1: styleselect | bold italic | link image | undo redo
    toolbar2: table | fullscreen
    plugins:
      - table
      - fullscreen
      
The Rails server no longer needs to be restarted when this file is updated in development mode.

To define multiple configuration sets, follow this syntax (a default configuration must be specified):

    default:
      plugins:
        - image
        - link
    
    alternate:
      selector: textarea.table-editor
      toolbar: styleselect | bold italic | link image | undo redo | table
      plugins:
        - table

See the [TinyMCE 4 Documentation](http://www.tinymce.com/wiki.php/Configuration) for a full list of configuration options.


**3. Include the TinyMCE assets**

Use *one* of the following options to include TinyMCE assets.

(1) Add to your application.js:

    //= require tinymce

or (2) with jQuery integration:

    //= require tinymce-jquery

(3) The TinyMCE assets can be included on a per-page basis using the `tinymce_assets` helper:

    <%= tinymce_assets %>
    #=> <script type="text/javascript" src="/assets/tinymce.js">


**4. Initialize TinyMCE**

For each textarea that you want to use with TinyMCE, add the "tinymce" class and ensure it has a unique ID:

    <%= text_area_tag :editor, "", :class => "tinymce", :rows => 40, :cols => 120 %>

Then invoke the `tinymce` helper to initialize TinyMCE:

    <%= tinymce %>

Custom options can be passed to `tinymce` to override the global options specified in `config/tinymce.yml`:

    <%= tinymce :theme => "simple", :language => "de", :plugins => ["wordcount", "paste"] %>

Alternate configurations defined in 'config/tinymce.yml' can be used with:

    <%= tinymce :alternate %>


Language Packs
--------------

See the [tinymce-rails-langs](https://github.com/spohlenz/tinymce-rails-langs) gem for additional language packs for TinyMCE. The `tinymce` helper will use the current locale as the language if available, falling back to English if the core language files are missing.


Manual Initialization
---------------------

Using the `tinymce` helper and global configuration file is entirely optional. The `tinyMCE.init` function can be invoked manually if desired.

    <%= text_area_tag :editor, "", :rows => 40, :cols => 120 %>

    <script type="text/javascript">
      tinyMCE.init({
        selector: 'textarea.editor'
      });
    </script>


Custom Plugins & Skins
----------------------

To use custom plugins or skins, simply add the files to your asset load path so that they are locatable at a path beneath `tinymce/plugins/` or `tinymce/skins/`.

For example, a plugin called `mycustomplugin` could have its main JS file at `app/assets/javascripts/tinymce/plugins/mycustomplugin/plugin.js`.

You should also ensure that your custom paths are added to the asset precompile paths.


Using tinymce-rails as an Engine Dependency
-------------------------------------------

Ensure that you explicitly require `tinymce-rails` within your engine file. Including tinymce-rails as a dependency in your gemspec is not enough.


Updating
--------

When new versions of TinyMCE are released, simply update the `tinymce-rails` gem to the latest version. There is no need to run any extra rake tasks (apart from `rake assets:precompile`).
