unless defined? TinyMCE::VERSION
  $:.unshift File.expand_path("../lib", __FILE__)
  require "tinymce/version"
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
  download("https://github.com/downloads/tinymce/tinymce/tinymce_#{TinyMCE::TINYMCE_VERSION}.zip", "tinymce.zip")
  download("https://github.com/downloads/tinymce/tinymce/tinymce_#{TinyMCE::TINYMCE_VERSION}_jquery.zip", "tinymce.jquery.zip")
end

task :extract do
  step "Extracting core files" do
    `rm -rf tmp/tinymce`
    `unzip -u tmp/tinymce.zip -d tmp`
    `rm -rf assets/precompiled/tinymce`
    `mkdir -p assets/precompiled/tinymce`
    `mv tmp/tinymce/jscripts/tiny_mce/* assets/precompiled/tinymce/`
  end
  
  step "Extracting jQuery files" do
    `rm -rf tmp/tinymce`
    `unzip -u tmp/tinymce.jquery.zip -d tmp`
    `mv tmp/tinymce/jscripts/tiny_mce/jquery.tinymce.js assets/precompiled/tinymce/jquery.tinymce.js`
    `mv tmp/tinymce/jscripts/tiny_mce/tiny_mce.js assets/precompiled/tinymce/tiny_mce_jquery.js`
    `mv tmp/tinymce/jscripts/tiny_mce/tiny_mce_src.js assets/precompiled/tinymce/tiny_mce_jquery_src.js`
  end
end

task :process do
  step "Fixing file encoding" do
    require 'iconv'
    converter = Iconv.new('UTF-8', 'ISO-8859-1')
    Dir["assets/precompiled/tinymce/**/*.js"].each do |file|
      contents = converter.iconv(File.read(file)).force_encoding('UTF-8')
      File.open(file, 'w') { |f| f.write(contents) }
    end
  end
  
  step "Copying includeable assets" do
    `cp assets/precompiled/tinymce/tiny_mce_src.js assets/vendor/tinymce/tiny_mce.js`
    `cp assets/precompiled/tinymce/tiny_mce_jquery_src.js assets/vendor/tinymce/tiny_mce_jquery.js`
    `cp assets/precompiled/tinymce/jquery.tinymce.js assets/vendor/tinymce/jquery-tinymce.js`
  end
end
