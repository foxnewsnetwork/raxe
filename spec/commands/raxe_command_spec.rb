require "raxe"

describe Raxe do
	describe Raxe::Commands do
		before(:each) do
			@raxe = Raxe.new
			@commands = Raxe::Commands.new( @raxe )
		end # before each
		
		describe "basics" do
			it "should respond to help displays" do
				@commands.should respond_to( :display_help )
			end # it
			it "should respond to error displays" do
				@commands.should respond_to( :display_error )
			end # it
		end # basics
	end # Raxe::Commands
end # Raxe
