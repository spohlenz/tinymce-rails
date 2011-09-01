namespace :tinymce do
  task :copy_assets do
    assets = File.expand_path(File.dirname(__FILE__) + "/../../assets/precompiled/tinymce")
    target = File.join(Rails.public_path, Rails.application.config.assets.prefix)
    
    mkdir_p target
    cp_r assets, target
  end
end

# Copy TinyMCE assets when assets:precompile rake task is called
Rake::Task['assets:precompile'].enhance(['tinymce:copy_assets'])
