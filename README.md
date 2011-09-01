Rails 3.1 Integration for TinyMCE
=================================

The `tinymce-rails` gem integrates the [TinyMCE](http://www.tinymce.com/) editor with the Rails 3.1 asset pipeline.


Instructions
------------

**1. Add `tinymce-rails` to your Gemfile**

    gem 'tinymce-rails'

Then run `bundle install`.


**2a. Use TinyMCE with the jQuery extension**

Add to your application.js:

    //= require tinymce-jquery

and use TinyMCE in your view:

    <%= text_area_tag :editor, "", :rows => 40, :cols => 120 %>

    <script type="text/javascript">
      $(function() {
        $('textarea').tinymce({
          theme: 'advanced'
        });
      });
    </script>


**2b. Use TinyMCE without jQuery**

Add to your application.js:

    //= require tinymce

Use TinyMCE in your view:

    <%= text_area_tag :editor, "", :rows => 40, :cols => 120 %>

    <script type="text/javascript">
      tinyMCE.init({
        mode: 'textareas',
        theme: 'advanced'
      });
    </script>


Updating
--------

When new versions of TinyMCE are released, simply update the `tinymce-rails` gem to the latest version. There is no need to run any extra rake tasks (apart from `rake assets:precompile`).
