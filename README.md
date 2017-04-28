Rails Integration for TinyMCE
=============================

The `tinymce-rails` gem integrates the [TinyMCE](http://www.tinymce.com/) editor with the Rails asset pipeline.

This gem is compatible with Rails 3.1.1 and higher (including Rails 4).

This is the branch for TinyMCE 4. For TinyMCE 3.5.x, please see the [tinymce-3 branch](https://github.com/spohlenz/tinymce-rails/tree/tinymce-3).

[![Build Status](https://travis-ci.org/spohlenz/tinymce-rails.png?branch=master)](https://travis-ci.org/spohlenz/tinymce-rails)

**New in 3.5.11, 4.1.10 and 4.2.1:** Alternative asset installation methods (copy vs compile/symlink). See the [Asset Compilation](#asset-compilation) section below for details.

Instructions
------------

**1. Add `tinymce-rails` to your Gemfile**

```ruby
gem 'tinymce-rails'
```

Be sure to add to the global group, not the `assets` group. Then run `bundle install`.


**2. Create a `config/tinymce.yml` file with your global configuration options:**

```yml
toolbar:
  - styleselect | bold italic | undo redo
  - image | link
plugins:
  - image
  - link
```

The Rails server no longer needs to be restarted when this file is updated in development mode.

To define multiple configuration sets, follow this syntax (a default configuration must be specified):

```yml
default:
  plugins:
    - image
    - link

alternate:
  selector: textarea.table-editor
  toolbar: styleselect | bold italic | undo redo | table
  plugins:
    - table
```

See the [TinyMCE 4 Documentation](https://www.tinymce.com/docs/configure/) for a full list of configuration options.


**3. Include the TinyMCE assets**

Use *one* of the following options to include TinyMCE assets.

(1) Add to your application.js:

```js
//= require tinymce
```

or (2) with jQuery integration:

```js
//= require tinymce-jquery
```

(3) The TinyMCE assets can be included on a per-page basis using the `tinymce_assets` helper:

```erb
<%= tinymce_assets %>
#=> <script type="text/javascript" src="/assets/tinymce.js">
```


**4. Initialize TinyMCE**

For each textarea that you want to use with TinyMCE, add the "tinymce" class and ensure it has a unique ID:

```erb
<%= text_area_tag :content, "", :class => "tinymce", :rows => 40, :cols => 120 %>
```

or if you are using Rails' form builders:

```erb
<%= f.text_area :content, :class => "tinymce", :rows => 40, :cols => 120 %>
```

Then invoke the `tinymce` helper to initialize TinyMCE:

```erb
<%= tinymce %>
```

Custom options can be passed to `tinymce` to override the global options specified in `config/tinymce.yml`:

```erb
<%= tinymce :theme => "simple", :language => "de", :plugins => ["wordcount", "paste"] %>
```

Alternate configurations defined in 'config/tinymce.yml' can be used with:

```erb
<%= tinymce :alternate %>
```


Language Packs
--------------

See the [tinymce-rails-langs](https://github.com/spohlenz/tinymce-rails-langs) gem for additional language packs for TinyMCE.


Manual Initialization
---------------------

Using the `tinymce` helper and global configuration file is entirely optional. The `tinyMCE.init` function can be invoked manually if desired.

```erb
<%= text_area_tag :editor, "", :rows => 40, :cols => 120 %>

<script type="text/javascript">
  tinyMCE.init({
    selector: 'textarea.editor'
  });
</script>
```


Asset Compilation
-----------------

Since TinyMCE loads most of its files dynamically, some workarounds are required to ensure that the TinyMCE asset files are accessible using non-digested filenames.

As of tinymce-rails 3.5.11, 4.1.10 and 4.2.1, two alternative asset installation methods are available, which can be changed by setting `config.tinymce.install` within your `config/application.rb` file. These methods are called when you run `rake asset:precompile` (via `Rake::Task#enhance`) after the regular application assets are compiled.

The default method (as of 4.5.2), `compile`, adds the TinyMCE paths to the Sprockets precompilation paths and then creates symlinks from the non-digested filenames to their digested versions.

```ruby
config.tinymce.install = :compile
```

If you experience issues with the `compile` method, you may wish to use the `copy` method instead, which copies the TinyMCE assets directly into `public/assets` and appends the file information into the asset manifest. The `copy_no_preserve` method is also available of you do not wish to or cannot preserve file modes on your filesystem.

```ruby
config.tinymce.install = :copy
```

If you are including TinyMCE via `application.js` or using the `tinymce_assets` helper, you do not need to manually alter the precompile paths. However if you wish to include `tinymce-jquery.js` independently (i.e. using `javascript_include_tag`), you will need to add it to the precompile list in `config/environments/production.rb`:

```ruby
config.assets.precompile << "tinymce-jquery.js"
```


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
