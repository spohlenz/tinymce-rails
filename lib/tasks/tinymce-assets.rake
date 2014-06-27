assets_task = Rake::Task.task_defined?('assets:precompile:primary') ? 'assets:precompile:primary' : 'assets:precompile'

Rake::Task[assets_task].enhance do
  require "tinymce/rails/asset_installer"

  assets = TinyMCE::Rails.configuration.options_for_tinymce['assets'] || []
  unless assets.blank?
    assets = assets.map {|a| Pathname.new(File.expand_path(Rails.root + a))}
  end

  assets += [Pathname.new(File.expand_path(File.dirname(__FILE__) + "/../../vendor/assets/javascripts/tinymce"))]

  config   = Rails.application.config
  target   = File.join(Rails.public_path, config.assets.prefix)
  manifest = config.assets.manifest

  TinyMCE::Rails::AssetInstaller.new(assets, target, manifest).install
end
