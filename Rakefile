unless defined? TinyMCE::Rails::VERSION
  $:.unshift File.expand_path("../lib", __FILE__)
  require "tinymce/rails/version"
end

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

desc "Update TinyMCE to version specified in lib/tinymce/version.rb"
task :update => [ :fetch, :extract, :process ]

task :fetch do
  download("https://github.com/downloads/tinymce/tinymce/tinymce_#{TinyMCE::Rails::VERSION}.zip", "tinymce.zip")
  download("https://github.com/downloads/tinymce/tinymce/tinymce_#{TinyMCE::Rails::VERSION}_jquery.zip", "tinymce.jquery.zip")
end

task :extract do
  step "Extracting core files" do
    `rm -rf tmp/tinymce`
    `unzip -u tmp/tinymce.zip -d tmp`
    `rm -rf vendor/assets/javascripts/tinymce`
    `mkdir -p vendor/assets/javascripts/tinymce`
    `mv tmp/tinymce/jscripts/tiny_mce/* vendor/assets/javascripts/tinymce/`
  end
  
  step "Extracting jQuery files" do
    `rm -rf tmp/tinymce`
    `unzip -u tmp/tinymce.jquery.zip -d tmp`
    `mv tmp/tinymce/jscripts/tiny_mce/jquery.tinymce.js vendor/assets/javascripts/tinymce/jquery.tinymce.js`
    `mv tmp/tinymce/jscripts/tiny_mce/tiny_mce.js vendor/assets/javascripts/tinymce/tiny_mce_jquery.js`
    `mv tmp/tinymce/jscripts/tiny_mce/tiny_mce_src.js vendor/assets/javascripts/tinymce/tiny_mce_jquery_src.js`
  end
end

task :process do
  step "Fixing file encoding" do
    require 'iconv'
    converter = Iconv.new('UTF-8', 'ISO-8859-1')
    Dir["vendor/assets/javascripts/tinymce/**/*.js"].each do |file|
      contents = converter.iconv(File.read(file)).force_encoding('UTF-8')
      File.open(file, 'w') { |f| f.write(contents) }
    end
  end
end
