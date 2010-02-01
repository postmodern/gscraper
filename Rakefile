# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'hoe/signing'
require './lib/gscraper/version.rb'

Hoe.spec('gscraper') do
  self.rubyforge_name = 'gscraper'
  self.developer('Postmodern', 'postmodern.mod3@gmail.com')

  self.rspec_options += ['--colour', '--format', 'specdoc']

  self.remote_rdoc_dir = ''
  self.extra_deps = [['mechanize', '>=0.9.0']]
end

# vim: syntax=Ruby
