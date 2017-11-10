window.TinyMCERails = {
  configuration: {
    default: {}
  },

  initialize: function(config, options) {
    if (typeof tinyMCE != 'undefined') {
      // Merge the custom options with the given configuration
      var configuration = TinyMCERails.configuration[config || 'default'];
      configuration = TinyMCERails._merge(configuration, options);

      tinyMCE.init(configuration);
    } else {
      // Wait until TinyMCE is loaded
      setTimeout(function() {
        TinyMCERails.initialize(config, options);
      }, 50);
    }
  },

  setupTurbolinks: function() {
    // Remove all TinyMCE instances before rendering
    document.addEventListener('turbolinks:before-render', function() {
      tinymce.remove();
    });
  },

  _merge: function() {
    var result = {};

    for (var i = 0; i < arguments.length; ++i) {
      var source = arguments[i];

      for (var key in source) {
        if (Object.prototype.hasOwnProperty.call(source, key)) {
          if (Object.prototype.toString.call(source[key]) === '[object Object]') {
            result[key] = TinyMCERails._merge(result[key], source[key]);
          } else {
            result[key] = source[key];
          }
        }
      }
    }

    return result;
  }
};

if (typeof Turbolinks != 'undefined' && Turbolinks.supported) {
  TinyMCERails.setupTurbolinks();
}
