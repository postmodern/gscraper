require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:development, :doc)
rescue Bundler::BundlerError => e
  STDERR.puts e.message
  STDERR.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'jeweler'
require './lib/gscraper/version.rb'

Jeweler::Tasks.new do |gem|
  gem.name = 'gscraper'
  gem.version = GScraper::VERSION
  gem.license = 'GPL-2'
  gem.summary = %Q{GScraper is a web-scraping interface to various Google Services.}
  gem.description = %Q{GScraper is a web-scraping interface to various Google Services.}
  gem.email = 'postmodern.mod3@gmail.com'
  gem.homepage = 'http://github.com/postmodern/gscraper'
  gem.authors = ['Postmodern']
  gem.has_rdoc = 'yard'
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new
task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
