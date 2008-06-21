require 'rubygems'
gem 'rspec', '>=1.1.3'
require 'spec'
require 'pathname'

require Pathname(__FILE__).dirname.join('helpers','query').expand_path
require Pathname(__FILE__).dirname.join('helpers','uri').expand_path
