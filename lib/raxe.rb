require "raxe/installer"
require "raxe/generator"
require "raxe/tasks"
require "raxe/commands"

# Raxe class
class Raxe
	attr_reader :paths, :setup_flag
	
	def initialize
		# Step 1: Checks for a conf file to load
		@paths = {}
		p_check_conf
		
		# Step 2: Setup the components
		@installer = Raxe::Installer.new( self )
		@generator = Raxe::Generator.new( self )
		@commands = Raxe::Commands.new( self )
	end # initialize
	
	def generate( generator_data )
		@generator.generate( generator_data )
	end # generate
	
	def install( installer_data = :install )
		install_data = { 
			:req => installer_data ,
			:callback => lambda { p_check_conf }
		} # install_data
		@installer.install( install_data )
	end # install
	
	def destroy( destroyer_data )
#		Raxe::Destroyer.destroy( destroy_data )
	end # destroy
	
	def build( builder_data )
#		Raxe::Builder.build( builder_data )
	end # build
	
	def commands( command_data )
		@commands.command( command_data )
	end # commands
	
	private 
		def p_check_conf
			conf_path = File.join( Dir.pwd, ".raxeconf" )
			if FileTest.exists?( conf_path )
				File.open( conf_path, "r" ) do |f|
					while line = f.gets
						item = line.split( "!!!" )
						@paths[item[0]] = item[1].strip
					end # while
				end # File.open
				@setup_flag = true
			else # if file exists
				@setup_flag = false
				@paths = {}
			end # if file exists
		end # p_check_conf
end # Raxe
