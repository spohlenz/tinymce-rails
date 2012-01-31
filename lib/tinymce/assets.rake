if Rake::Task.task_defined?('assets:precompile:primary')
  task = 'assets:precompile:primary'
else
  # Rails 3.1.0
  task = 'assets:precompile'
end

Rake::Task[task].enhance do
  assets = File.expand_path(File.dirname(__FILE__) + "/../../assets/precompiled/tinymce")
  target = File.join(Rails.public_path, Rails.application.config.assets.prefix)
  
  mkdir_p target
  cp_r assets, target
end
