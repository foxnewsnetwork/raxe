require "raxe"

describe Raxe do
	describe Raxe::Generator do
		before(:each) do
			@raxe = Raxe.new
			@raxe.install
			@generator = Raxe::Generator.new( @raxe )
		end # before each
		after(:each) do
			@raxe.install(:uninstall)
		end # after each
		describe "generating packages" do
			before(:each) do
				@packname = "lolcat"
				@expected = [ '','data','spec'].map do | x | 
					File.join( @raxe.paths['source'] , @packname + x )
				end # expected
			end # before each
			after(:each) do
				@generator.kill_packages( @packname )
			end # after each
			it "should allow for successful package creation" do
				@generator.make_packages( @packname )
				@expected.each do | folder |
					FileTest.exists?( folder ).should be_true
				end # expected
			end # it
		end # generating packages
		describe "generating files into packages" do
			before(:each) do
				@packname = "happycat"
				@filename = "faggot"
				@expected = ["", "data", "spec"].map do | x | 
					File.join(@raxe.paths['source'], File.join(@packname + x, @filename.capitalize + x.capitalize + ".hx" ) ) 
				end # expected
				@generator.make_packages( @packname )
			end # before each
			after(:each) do
				@generator.kill_files( @packname, @filename )
				@generator.kill_packages( @packname )
			end # after each
			it "should allow for successful file creation" do
				@generator.make_files( @packname, @filename )
				@expected.each do | file |
					FileTest.exists?( file ).should be_true
				end # expected each
			end # it
		end # generating files
	end # Raxe::Generator
end # Raxe
