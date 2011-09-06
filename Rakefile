require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Generate documentation for the session_captcha plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'SessionCaptcha'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README', 'lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "session_captcha"
    gemspec.version = '0.0.1'
    gemspec.summary = "SessionCaptcha is an easy to use CAPTCHA plugin that uses the session to temporarily store the hashed value of the generated secret."
    gemspec.description = "SessionCaptcha is an easy to use CAPTCHA plugin that uses the session to temporarily store the hashed value of the generated secret. The secret and image are securely destroyed after completion of the transaction."
    gemspec.email = ""
    gemspec.homepage = ""
    gemspec.authors = ["Kjel Delaey"]
    gemspec.files = FileList["[A-Z]*", "{lib}/**/*"]
    gemspec.rubyforge_project = ""
  end
  
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
