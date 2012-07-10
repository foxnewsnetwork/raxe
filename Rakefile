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
  gem.summary = %Q{TODO: one-line summary of your gem}
  gem.description = %Q{TODO: longer description of your gem}
  gem.email = "foxnewsnetwork@gmail.com"
  gem.authors = ["Yuki Nagato"]
  # dependencies defined in Gemfile
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

namespace :raxe do
	desc "cleans out the testing environment; useful only in testing"
	task :clean_tests do
		sh "rm raxe -r"
	end # clean
	
	desc "gets and installs haXe if it isn't found (only works on Linux)"
	task :gethaxe do
		begin
			puts "Let's see if you have haxe installed..."
			sh "which haxe"
			puts "Great! It looks like haXe has already been installed."
		rescue
			puts "Grabbing the tar ball from haxe.org..."
			sh "wget http://haxe.org/file/hxinst-linux.tgz"
			puts "Extracting the tar ball..."
			sh "tar -xvf hxinst-linux.tgz"
			puts "Changing permission to run the installer executable"
			sh "chmod 755 hxinst-linux"
			puts "Running the executable"
			sh "./hxinst-linux"
			puts "Cleaning up"
			sh "rm hxinst-linux"
			sh "rm hxinst-linux.tgz"
			puts "Finished installing haxe"
		end # begin-rescue
	end # gethaxe	
		
	desc "installs raxe into the current project"
	task :install => [:gethaxe]
	task :install do
		root_dir = "raxe"
		unless FileTest.exists? root_dir
			Dir.mkdir root_dir 
			puts "Created directory " + root_dir
		else
			puts "Directory " + root_dir + " already exists. Skiping to next step."
		end # exists
		[ "src", "out", "tests" ].each do |f|
			folder = root_dir + "/" + f
			unless FileTest.exists? folder
				Dir.mkdir folder 
				puts "Created directory " + folder
			else
				puts "Directory " + folder + " already exists. Skipping to next step."
			end # exists
		end # each
		Dir.chdir root_dir
		puts "Switching directory to " + root_dir
		File.open( "raxe.conf.rb", "w+") do |f|
			f.puts "# Raxe Configuration File!"
			f.puts "# As of the current version, you need to have haXe installed"
			f.puts "# before you can use this junk. Eventually, though, I imagine"
			f.puts "# I will get the install command to install haXe on its own"
			f.puts "class RaxeConfiguration"
			f.puts "\t@@root_path = \"" + Dir.pwd + "\""
			f.puts "\t@@raxe_path = \"" + File.join( Dir.pwd, "raxe" ) + "\""
			f.puts "\t@@production_out_path = \"" + File.join( Dir.pwd, "raxe/out" ) + "\""
			f.puts "\t@@tests_path = \"" + File.join(Dir.pwd, "raxe/test" ) + "\""
			f.puts "end # RaxeConfiguration"
		end # File.open
		puts "Wrote raxe.conf.rb"
		File.open( "build.hxml", "w+" ) do |f|
			f.puts "# haXe output instructions go here. Uncommented whatever you need"
			f.puts "# -js out/raxe.js"
			f.puts "# -main raxetest.RaxeFire"
		end # File.open
		puts "Wrote build.hxml"
		puts "Done!"
	end # install
end # raxe
