require File.expand_path('../lib/tinymce/rails/version', __FILE__)

def step(name)
  print "#{name} ..."
  yield
  puts " DONE"
end

def download(url, filename)
  puts "Downloading #{url} ..."
  `mkdir -p tmp`
  `curl -L -# #{url} -o tmp/#{filename}`
end

desc "Update TinyMCE to version #{TinyMCE::Rails::TINYMCE_VERSION}"
task :update => [ :fetch, :extract, :rename ]

task :fetch do
  download("http://download.moxiecode.com/tinymce/tinymce_#{TinyMCE::Rails::TINYMCE_VERSION}.zip", "tinymce.zip")
  download("http://download.moxiecode.com/tinymce/tinymce_#{TinyMCE::Rails::TINYMCE_VERSION}_dev.zip", "tinymce.dev.zip")
end

task :extract do
  step "Extracting core files" do
    `rm -rf tmp/tinymce`
    `unzip -u tmp/tinymce.zip -d tmp`
    `rm -rf app/assets/javascripts/tinymce`
    `mkdir -p app/assets/javascripts/tinymce`
    `mv tmp/tinymce/js/tinymce/* app/assets/javascripts/tinymce/`
  end
  
  step "Extracting jQuery & unminified source files" do
   `rm -rf tmp/tinymce`
   `unzip -u tmp/tinymce.dev.zip -d tmp`
   `mv tmp/tinymce/js/tinymce/jquery.tinymce.min.js app/assets/javascripts/tinymce/jquery.tinymce.js`
   `mv tmp/tinymce/js/tinymce/tinymce.jquery.min.js app/assets/javascripts/tinymce/tinymce.jquery.js`
   `mkdir -p app/assets/source/tinymce`
   `mv tmp/tinymce/js/tinymce/tinymce.js app/assets/source/tinymce/tinymce.js`
   `mv tmp/tinymce/js/tinymce/tinymce.jquery.js app/assets/source/tinymce/tinymce.jquery.js`
  end
end

task :rename do
  step "Renaming files" do
    Dir["app/assets/javascripts/tinymce/**/*.min.js"].each do |file|
      FileUtils.mv(file, file.sub(/\.min\.js$/, '.js'))
    end
  end
end


require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :default => :spec
