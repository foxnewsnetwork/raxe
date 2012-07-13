require "rake"
# require "raxe"

class Raxe
	class Installer
		
		def initialize( raxe )
			@raxe = raxe
		end # initialize
		
		def self.get_haxe
			# TODO: figure out a better way of doing this... seriously...
			# FIXME: Actually test this method lol
			begin
				puts "	Let's see if you have haxe installed..."
				sh "which haxe"
				puts "	Great! It looks like haXe has already been installed."
			rescue
				puts "	Grabbing the tar ball from haxe.org..."
				sh "wget http://haxe.org/file/hxinst-linux.tgz"
				puts "	Extracting the tar ball..."
				sh "tar -xvf hxinst-linux.tgz"
				puts "	Changing permission to run the installer executable"
				sh "chmod 755 hxinst-linux"
				puts "	Running the executable"
				sh "./hxinst-linux"
				puts "	Cleaning up"
				sh "rm hxinst-linux"
				sh "rm hxinst-linux.tgz"
				puts "	Finished installing haxe"
			end # begin-rescue
		end # check_haxe
	
		def install( install_data )
			case install_data[:req]
				when :install
					Installer.make_conf_file
					Installer.make_content
				when :uninstall
					Installer.kill_conf_file
					kill_content
			end # case req
			install_data[:callback].call
		end # self.install
		
		def self.kill_conf_file
			filename = File.join( Dir.pwd, ".raxeconf" )
			File.delete( filename ) if FileTest.exists? filename 
		end # self.kill_conf_file
		
		def self.make_conf_file
			configurations = { 
				"root" => "raxe" ,
				"output" => "raxe/out" ,
				"source" => "raxe/src",
				"tests" => "raxe/tests"
			} # configuration
			File.open( File.join( Dir.pwd, ".raxeconf" ), "w+" ) do |f|
				configurations.each do |key, val|
					f.puts key + "!!!" + val
				end # configurations.each
			end # File.open
		end # self.raxe_conf		
	
		def kill_content
			kill_recursively = lambda do |dir|
				begin
					Dir.delete( dir ) unless Dir.entries( dir ).length > 2
				rescue
					dir.foreach do |item|
						File.delete( item ) if File.file? item
						kill_recursively.call( item ) if Dir.directory? item &&  item != "." && item != ".."
					end # dir.foreach
				end # begin-rescue
			end # kill_recursively
			@raxe.paths.each do |type, location|
				next if type == "root"
				kill_recursively.call( location )
			end # @raxe.paths
			File.delete( File.join( @raxe.paths['root'], "build.hxml" ) ) if FileTest.exists? File.join( @raxe.paths['root'], "build.hxml" )
			puts "	Deleted build.hxml"
			Dir.delete( @raxe.paths["root"] ) if Dir.entries( @raxe.paths["root"] ).length < 3
		end # kill_content
		
		def self.make_content
			root_dir = "raxe"
			unless FileTest.exists? root_dir
				Dir.mkdir root_dir 
				puts "	Created directory " + root_dir
			else
				puts "	Directory " + root_dir + " already exists. Skiping to next step."
			end # exists
			[ "src", "out", "tests" ].each do |f|
				folder = File.join( root_dir , f )
				unless FileTest.exists? folder
					Dir.mkdir folder 
					puts "	Created directory " + folder
				else
					puts "	Directory " + folder + " already exists. Skipping to next step."
				end # exists
			end # each
			File.open( File.join( root_dir, "build.hxml" ), "w+" ) do |f|
				f.puts "# haXe output instructions go here. Uncommented whatever you need"
				f.puts "# -js out/raxe.js"
				f.puts "# -main raxetest.RaxeFire"
			end # File.open
			puts "	Wrote build.hxml"
			puts "	Done!"
		end # self.install
	end # Installer
end # Raxe
