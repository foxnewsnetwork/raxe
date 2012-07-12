require "raxe"

describe Raxe do
	describe "initialization" do
		describe "naked" do
			before(:each) do
				@raxe = Raxe.new
			end # before each
			it "should have a blank path" do
				@raxe.paths.should be_empty
			end # it
			it "should not be properly setup" do
				@raxe.setup_flag.should be_false
			end # it
		end # naked
		describe "has conf" do
			before(:each) do
				@filename = File.join( Dir.pwd, ".raxeconf" )
				@junk = { 
					"root" => "raxe" ,
					"output" => "raxe/out" ,
					"source" => "raxe/src",
					"tests" => "raxe/tests"
				} # junk
				File.open( @filename, "w+" ) do |f|
					@junk.each do |key, val|
						f.puts key + "!!!" + val
					end # junk each
				end # File.open
				@raxe = Raxe.new
			end # before each
			after(:each) do
				File.delete( @filename )
			end # after each
			it "should be properly setup" do
				@raxe.setup_flag.should be_true
			end # it
			it "should have the correct paths" do
				@junk.each do |key, val|
					@raxe.paths[key].should eq(val)
				end # junk.each
			end # it
		end # has conf
	end # initialization
	describe "installation" do
		before(:each) do
			@raxe = Raxe.new
			@expected = { 
				"root" => "raxe" ,
				"output" => "raxe/out" ,
				"source" => "raxe/src",
				"tests" => "raxe/tests"
			} # expected
		end # before each
		after(:each) do
			@raxe.install( :uninstall )
		end # after each
		it "should modify the flags and whatnot after a successful installation" do
			@raxe.install
			@raxe.setup_flag.should be_true
			@raxe.paths.each do | type, location |
				@expected[type].should eq( location )
			end # paths.each
		end # it
	end # installation
	describe "uninstallation" do
		before(:each) do
			@raxe = Raxe.new
			@raxe.install
		end # before each
		it "should have reset the proper flags and paths" do
			@raxe.install( :uninstall )
			@raxe.setup_flag.should be_false
			@raxe.paths.should be_empty
		end # it
	end # uninstallation
	describe "generation" do
		before(:each) do
			@raxe = Raxe.new
			@raxe.install
			@packname = "faggot"
			@filename = "trevor"
			@expected = { 
				:file => ['','data','spec'].map { | x | File.join(File.join(@raxe.paths['source'], @packname + x), @filename.capitalize + x.capitalize + ".hx" ) } ,
				:folder => ['','data','spec'].map { | x | File.join( @raxe.paths['source'], @packname + x ) }
			} # expected
		end # before each
		after(:each) do
			@raxe.generate( :req => :ungenerate, :package => @packname, :file => @filename  )
			@raxe.install(:uninstall)
		end # after each
		it "should successfully create the desried package" do
			@raxe.generate( :req => :generate , :package => @packname , :file => @filename )
			@expected[:file].each do | file |
				FileTest.exists?( file ).should be_true
			end # expected
			@expected[:folder].each do | folder |
				Dir.exists?( folder ).should be_true
			end # expected
		end # it
	end # generation
	describe "ungeneration" do
		before( :each ) do
			@raxe = Raxe.new
			@raxe.install
			@packname = "faggot"
			@filename = "trevor"
			@expected = { 
				:file => ['','data','spec'].map { | x | File.join(File.join(@raxe.paths['source'], @packname + x), @filename.capitalize + x.capitalize + ".hx" ) } ,
				:folder => ['','data','spec'].map { | x | File.join( @raxe.paths['source'], @packname + x ) }
			} # expected
			@raxe.generate( :req => :generate , :package => @packname , :file => @filename )
		end # before each
		it "should destroy all the unnecessary crap" do
			@raxe.generate( :req => :ungenerate, :package => @packname, :file => @filename  )
			@expected[:file].each do | file |
				FileTest.exists?( file ).should be_false
			end # expected
			@expected[:folder].each do |folder|
				Dir.exists?( folder ).should be_false
			end # expected
		end # it
	end # ungeneration
end # Raxe
