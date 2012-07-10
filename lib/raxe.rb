# main function lives in here

class Raxe
	@@output_path = File.join( Dir.pwd , "tests" )
	
	def self.out_path
		return @@output_path
	end #  self.out_path
	
	def self.out_path=( path )
		@@output_path = path
	end # self.out_path
	
	def self.generate( package, file )
		# Step 1 : Generating files
		original = self.gen(package, file)
		spec = self.gen(package + "spec", file + "Spec")
		data = self.gen(package + "data", file + "Data")
		
		# Step 1.5: Generating content
		original_content = "import #{package}data.#{file.capitalize}Data;\n"
		original_content += "class #{file.capitalize} { \n"
		original_content += "\tprivate var #{file}data : #{file.capitalize}Data; \n"
		original_content += "\t public function new () { } // new \n"
		original_content += "} // #{file.capitalize}"
		# Step 2: Writing content
		self.append2file( original, original_content)
		
		spec_content = "import #{package}data.#{file.capitalize}Data;\n"
		spec_content += "import #{package}.#{file.capitalize};\n"
		spec_content += "class #{file.capitalize}Spec extends haxespec.FuryTestCase { \n"
		spec_content += "\t public override function setup () { } // setup \n"
		spec_content += "\t public override function tearDown () { } // tearDown \n"
		spec_content += "} // #{file.capitalize}Spec"
		self.append2file( spec, spec_content )
		
		data_content = "typedef #{file.capitalize}Data = { \n"
		data_content += "} // #{file.capitalize}Data "
		self.append2file( data, data_content )
	end # self.generate
	
	private
		def self.append2file( file, content )
			File.open( file, "a+" ) do |f|
				f.puts content
			end # File.open
		end # self.writefile
	
		def self.gen( package, file )
			path = File.join( self.out_path , package )
			Dir.chdir( self.out_path )
			Dir.mkdir( path ) unless FileTest.exists? ( path )
			Dir.chdir( path )
			if FileTest.exists?( file.capitalize + ".hx" )
				puts "Error: the package + file combo you've specified already exists!"
				return
			end # FileTest.exists?
			File.open( file.capitalize + ".hx", "w+" ) do |f|
				f.puts "package #{package};"
			end # File.open
			return File.join( path, file.capitalize + ".hx" )
		end # self.gen
end # Raxe
