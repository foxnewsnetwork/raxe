# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "raxe"
  gem.homepage = "http://github.com/foxnewsnetwork/raxe"
  gem.license = "MIT"
  gem.summary = %Q{haxe-based javascript generator engine for ruby on rails (current under development)}
  gem.description = %Q{Written as a ruby gem, raxe is a series of macros for writing simpler haxe code for javascript compilation}
  gem.email = "foxnewsnetwork@gmail.com"
  gem.authors = ["Yuki Nagato", "Madotsuki"]
  # dependencies defined in Gemfile
  gem.add_dependency 'colorize'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

# require 'rcov/rcovtask'
# Rcov::RcovTask.new do |test|
#  test.libs << 'test'
#  test.pattern = 'test/**/test_*.rb'
#  test.verbose = true
#  test.rcov_opts << '--exclude "gems/*"'
# end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "raxe #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

$: << File.join( File.dirname( __FILE__ )  , "lib" )
require "raxe"
Raxe::Tasks.new( Raxe.new )
