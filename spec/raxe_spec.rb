require "raxe"

describe Raxe do
	describe "directory access" do
		describe "basic functionality" do
			it "should have a proper output path" do
				Raxe.out_path.should_not be_nil
			end # it
			it "should have the default output path set to javascripts/raxe" do
				Raxe.out_path.should eq( File.join( Dir.pwd, "raxe/src" ) )
			end # it
			it "should allow for changing the output directory" do
				Raxe.out_path = File.dirname( __FILE__ ) 
				Raxe.out_path.should eq File.dirname( __FILE__ )
			end # it
		end # basic functionality
	end # making directories
	describe "package generation" do
		before(:each) do
			@package = "package"
			@file = "file"
			Raxe.out_path = File.join( Dir.pwd, "raxe/src" )
		end # before
		it "should generate the package directory, files, and associated items" do
			Raxe.generate( @package, @file )
			package_path = File.join(Raxe.out_path , @package )
			file_path = File.join( Raxe.out_path, @package, @file.capitalize + ".hx" )
			["", "spec","data"].each do |type|
				FileTest.exists?( package_path + type ).should be_true
				FileTest.exists?( file_path ).should be_true
			end # each type
		end # it
	end # package generation
end # Raxe
