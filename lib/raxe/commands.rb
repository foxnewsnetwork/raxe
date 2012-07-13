# require "raxe"

class Raxe
	class Commands
		def initialize( raxe )
			@raxe = raxe
		end # initialize
		
		def command( command_data )
			if command_data.nil? || command_data.empty?
				display_help
			else
				case command_data[0]
					when "install", "uninstall"
						c = command_data[0] == "uninstall" ? :uninstall : nil
						@raxe.install(c)
					when "generate", "ungenerate"
						c = command_data[0] == "generate" ? :generate : :ungenerate
						p = command_data[1]
						f = command_data[2]
						if p.nil? || f.nil?
							display_error
							return -1
						else
							@raxe.generate( :req => c, :package => p, :file => f )
						end # if bad cmds
					when "routes"
						if @raxe.setup_flag
							puts @raxe.paths
						else
							puts "Raxe has not been installed yet. Consider installing before using"
						end # if installed
					else
						display_help
				end # case command_data
			end # if null command
			return 0
		end # commands
		
		def display_help
			puts "Usage : raxe [command] [arguments]"
			puts "Commands : "
			puts "	install	# installs the raxe application into the current workspace"
			puts "	uninstall	# removes the raxe application if there is one in the current workspace"
			puts "	generate [package] [file]	# generates a standard raxe package"
			puts "	ungenerate [package] [file]	# removes the named package if it exists"
			puts "	routes	# shows the current haxe pathing"
		end # display_help
		
		def display_error
			puts "Bad usage, you're probably missing some parameters or put in too many."
		end # display_error
	end # Commands
end # Raxe
