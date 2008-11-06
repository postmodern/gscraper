# -*- ruby -*-

require 'rubygems'
require 'hoe'

require './tasks/spec.rb'
require './lib/gscraper/version.rb'

Hoe.new('gscraper', GScraper::VERSION) do |p|
  p.rubyforge_name = 'gscraper'
  p.developer('Postmodern', 'postmodern.mod3@gmail.com')
  p.remote_rdoc_dir = ''
  p.extra_deps = ['hpricot', 'mechanize']
end

# vim: syntax=Ruby
