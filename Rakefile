unless defined? TinyMCE::VERSION
  $:.unshift File.expand_path("../lib", __FILE__)
  require "tinymce/version"
end

def step(name)
  print "#{name} ..."
  yield
  puts " DONE"
end

namespace :tinymce do
  desc "Update TinyMCE to version specified in lib/tinymce/version.rb"
  task :update => [ :fetch, :extract, :process ]
  
  task :fetch do
    url = "https://github.com/downloads/tinymce/tinymce/tinymce_#{TinyMCE::VERSION}_jquery.zip"
    puts "Downloading #{url} ..."
    `mkdir -p tmp`
    `curl -L -# #{url} -o tmp/tinymce.zip`
  end
  
  task :extract do
    step "Extracting files" do
      `unzip -u tmp/tinymce.zip -d tmp`
    end
    
    step "Moving files into assets/vendor" do
      `rm -rf assets/vendor/tinymce`
      `mkdir -p assets/vendor/tinymce`
      `mv tmp/tinymce/jscripts/tiny_mce/* assets/vendor/tinymce/`
    end
  end
  
  task :process do
    step "Removing minified versions" do
      Dir["assets/vendor/tinymce/**/*_src.js"].each do |file|
        `rm #{file.sub("_src", "")}`
        `mv #{file} #{file.sub("_src", "")}`
      end
    end
    
    step "Fixing file encoding" do
      require 'iconv'
      converter = Iconv.new('UTF-8', 'ISO-8859-1')
      Dir["assets/vendor/tinymce/**/*.js"].each do |file|
        contents = converter.iconv(File.read(file)).force_encoding('UTF-8')
        File.open(file, 'w') { |f| f.write(contents) }
      end
    end
  end
end
