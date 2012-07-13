require 'rake'
require 'rake/tasklib'


class Rake::Application
	attr_accessor :raxe_tasks
	def raxe
		return raxe_tasks.raxe
	end # raxe
end # Rake::Application

class Raxe
	class Tasks< ::Rake::TaskLib
		attr_accessor:raxe, :raxe_builder
		
		def initialize( raxe )
			@raxe = raxe
			Rake.application.raxe_tasks = self
			define_tasks()
		end # initialize	
		
		private
			def define_tasks()
				require "raxe/installer"
				namespace :raxe do
					desc "cleans out the testing environment; useful only in testing"
					task :clean_tests do
						sh "rm raxe -r"
					end # clean
	
					desc "gets and installs haXe if it isn't found (only works on Linux)"
					task :gethaxe do
						Raxe::Installer.get_haxe
					end # gethaxe	
		
					desc "installs raxe into the current project"
					task :install => [:gethaxe]
					task :install do
						@raxe.install
					end # install
				end # raxe
			end # define_tasks
	end # Tasks
end # Raxe

