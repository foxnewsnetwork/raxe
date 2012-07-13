# require "raxe"

class Raxe
	class Generator
		
		def initialize( raxe )
			@raxe = raxe
		end # initialize	
		
		def generate(generate_data)
			case generate_data[:req]
				when :generate
					make_packages( generate_data[:package] )
					make_files( generate_data[:package], generate_data[:file] )
				when :ungenerate
					kill_files( generate_data[:package], generate_data[:file] ) 
					kill_packages( generate_data[:package] )
			end # case req
		end # generate
	
		def kill_files( package, file )
			# Step 1 : Check existence
			flags = p_check_file_existence( package, file )
			
			# Step 2 : Remove the ones who exist
			flags.each do | path, status |
				if status
					File.delete( path ) 
					puts "	Deleted file " + path
				else # status
					puts "	File " + path + " does not exist"
				end # status
			end # flags.each
		end # kill_files
		
		def make_files( package, file )
			# Step 1 : Check existence
			flags = p_check_file_existence( package, file )
			
			# Step 1.5 : Generate file content
			contents = p_generate_file_content( package, file )
			
			# Step 2: Make the ones who do not exist
			flags.each do | path, status |
				if status
					puts "	File " + path + " already exists..."
				else # status
					File.open( path, "w+" ) do |f|
						f.puts contents[path]
					end # File.open
					puts "	Created file " + path
				end # if status
			end # flags each
		end # make_files		
		
		def kill_packages( who )
			# Step 1: Check existence
			flags = p_check_package_existence( who )
			
			# Step 2: Kill the ones who exist (if dir is empty)
			flags.each do |path, status|
				if status
					if Dir.entries( path ).length < 3
						Dir.delete( path ) 
						puts "	Deleted directory " + path 
					else # has stuff
						puts "	Directory " + path + " cannot be delete because it has stuff in it"
					end # if
				else # status
					puts "	Directory " + path + " does not exist"
				end # status
			end # flags.each
		end # kill_packages
		
		def make_packages( who )
			# Step 1: Check existence
			flags = p_check_package_existence( who )
			
			# Step 2: Create the ones who do not exist
			flags.each do | path, status |
				if status
					puts "	Directory " + path + " already exists"
				else # status
					Dir.mkdir( path )
					puts "	Created directory " + path
				end # status
			end # flags each
		end # make_package
		
		private
			def p_generate_file_content( package, file )
				original_content = "import #{package}data.#{file.capitalize}Data;\n"
				original_content += "class #{file.capitalize} { \n"
				original_content += "\tprivate var #{file}data : #{file.capitalize}Data; \n"
				original_content += "\t public function new () { } // new \n"
				original_content += "} // #{file.capitalize}"
				
				spec_content = "import #{package}data.#{file.capitalize}Data;\n"
				spec_content += "import #{package}.#{file.capitalize};\n"
				spec_content += "class #{file.capitalize}Spec extends haxespec.FuryTestCase { \n"
				spec_content += "\t public override function setup () { } // setup \n"
				spec_content += "\t public override function tearDown () { } // tearDown \n"
				spec_content += "} // #{file.capitalize}Spec"
				
				data_content = "typedef #{file.capitalize}Data = { \n"
				data_content += "} // #{file.capitalize}Data "
				
				paths = ['','data','spec'].map { | x | File.join(File.join( @raxe.paths['source'], package + x ), file.capitalize + x.capitalize + ".hx" ) }
				return { 
					paths[0] => original_content ,
					paths[1] => spec_content ,
					paths[2] => data_content 
				} # return
			end # generate_file_content
			
			def p_check_package_existence( package )
				p_check_existence( ['','data','spec'].map { | x | package + x } )
			end # p_check_package_existence
			
			def p_check_file_existence( package, file )
				p_check_existence( ['', 'data','spec'].map { | x | File.join( package + x, file.capitalize + x.capitalize + ".hx" ) } ) 
			end # p_check_file_existence
			
			def p_check_existence( expected )
				flags = {}
				expected.each do | folder |
					path = File.join( @raxe.paths['source'], folder )
					flags[path] = FileTest.exists?( path )
				end # expected
				return flags
			end # p_check_existence
	end # Generator
end # Raxe
