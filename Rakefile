unless defined? TinyMCE::VERSION
  $:.unshift File.expand_path("../lib", __FILE__)
  require "tinymce/version"
end

def step(name)
  print "#{name} ..."
  yield
  puts " DONE"
end

desc "Update TinyMCE to version specified in lib/tinymce/version.rb"
task :update => [ :fetch, :extract, :process ]

task :fetch do
  url = "https://github.com/downloads/tinymce/tinymce/tinymce_#{TinyMCE::TINYMCE_VERSION}_jquery.zip"
  puts "Downloading #{url} ..."
  `mkdir -p tmp`
  `curl -L -# #{url} -o tmp/tinymce.zip`
end

task :extract do
  step "Extracting files" do
    `unzip -u tmp/tinymce.zip -d tmp`
  end
  
  step "Moving files into tinymce/" do
    `rm -rf tinymce`
    `mkdir -p tinymce`
    `mv tmp/tinymce/jscripts/tiny_mce/* tinymce/`
  end
end

task :process do
  step "Copying assets for asset pipeline" do
    `cp tinymce/tiny_mce_src.js assets/vendor/tinymce/tiny_mce.js`
    `cp tinymce/jquery.tinymce.js assets/vendor/tinymce/jquery-tinymce.js`
  end
end
