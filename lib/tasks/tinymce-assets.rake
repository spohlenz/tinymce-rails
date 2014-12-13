assets_task = Rake::Task.task_defined?('assets:precompile:primary') ? 'assets:precompile:primary' : 'assets:precompile'

Rake::Task[assets_task].enhance do
  require "tinymce/rails/asset_installer"

  assets = Pathname.new(File.expand_path(File.dirname(__FILE__) + "/../../vendor/assets/javascripts/tinymce"))
  
  config   = Rails.application.config
  target   = File.join(Rails.public_path, config.assets.prefix)
  manifest = config.assets.manifest
  
  installer = TinyMCE::Rails::AssetInstaller.new(assets, target, manifest)
  installer.log_level = Logger::INFO
  
  if config.tinymce.install == :compile
    installer.strategy = TinyMCE::Rails::AssetInstaller::Symlink
  else
    installer.strategy = TinyMCE::Rails::AssetInstaller::Copy
  end
  
  installer.install
end
