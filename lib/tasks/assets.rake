Rake::Task['assets:precompile:primary'].enhance do
  assets = File.expand_path(File.dirname(__FILE__) + "/../../vendor/assets/javascripts/tinymce")
  target = File.join(Rails.public_path, Rails.application.config.assets.prefix)

  mkdir_p target
  cp_r assets, target
end
