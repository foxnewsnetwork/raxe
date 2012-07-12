require "raxe"

describe Raxe do
	describe Raxe::Installer do
		describe "conf file deletion" do
			before(:each) do
				Raxe::Installer.make_conf_file
			end # before each
			after(:each) do
				File.delete( ".raxeconf" ) if FileTest.exists?( ".raxeconf" )
			end # after each
			it "should kill the conf file" do
				Raxe::Installer.kill_conf_file
				FileTest.exists?( ".raxeconf" ).should be_false
			end # it
		end # conf file deletion
		describe "conf file creation" do
			before(:each) do
				@defaults = { 
					"root" => "raxe" ,
					"output" => "raxe/out" ,
					"source" => "raxe/src",
					"tests" => "raxe/tests"
				} # defaults
				@filename = File.join( Dir.pwd, ".raxeconf" )
			end # before each
			after(:each) do
				File.delete( @filename ) if FileTest.exists?( @filename )
			end # after each
			it "should have the proper defaults" do
				Raxe::Installer.make_conf_file
				FileTest.exists?( @filename ).should be_true
				File.open( @filename, "r" ) do |f| 
					while line = f.gets
						item = line.split("!!!")
						@defaults[item[0]].should eq( item[1].strip )
					end # while
				end # File.open
			end # it
		end # conf file creation
		describe "folder uninstallation" do
			before(:each) do
				@root = File.join( Dir.pwd, 'raxe'  )
				@trunk = ['out','src','tests']
				@expected= { :folders => @trunk.map { |x| File.join( @root, x ) }, :files => [File.join( @root, 'build.hxml' )] }
				
				@raxe = Raxe.new
				@installer = Raxe::Installer.new( @raxe )
				@raxe.install
			end # before each
			after(:each) do
				@expected[:folders].each do | folder |
					Dir.delete( folder ) if Dir.exists? folder
				end # each folder
				@expected[:files].each do | file |
					File.delete( file ) if FileTest.exists? file
				end # each file
				Dir.delete( @root ) if Dir.exists? @root
			end # after each
			it "should delete everything" do
				@raxe.install(:uninstall)
				@expected[:folders].each do |folder|
					FileTest.exists?( folder ).should be_false
				end # each folder
				@expected[:files].each do |file|
					FileTest.exists?( file ).should be_false
				end # each file
			end # it
		end # folder uninstallation
		describe "folder installation" do
			describe "pure naked" do
				before( :each ) do
					@root = File.join( Dir.pwd, 'raxe'  )
					@trunk = ['out','src','tests']
					@expected= { :folders => @trunk.map { |x| File.join( @root, x ) }, :files => [File.join( @root, 'build.hxml' )] }
				end # before each
				after( :each ) do
					@expected[:folders].each do | folder |
						Dir.delete( folder ) if Dir.exists? folder
					end # each folder
					@expected[:files].each do | file |
						File.delete( file ) if FileTest.exists? file
					end # each file
					Dir.delete( @root ) if Dir.exists? @root
				end # after
				it "should create all the expected files and folders" do
					Raxe::Installer.make_content
					@expected.each do | type, items |
						items.each do |item|
							FileTest.exists?( item ).should be_true
						end # each item
					end # expected each
				end # it
			end # pure naked
			describe "some stuff exists" do
				before( :each ) do
					@root = File.join( Dir.pwd, 'raxe'  )
					@trunk = ['out','src','tests']
					@expected= { :folders => @trunk.map { |x| File.join( @root, x ) }, :files => [File.join( @root, 'build.hxml' )] }
					Raxe::Installer.make_content
				end # before each
				after( :each ) do
					@expected[:folders].each do | folder |
						Dir.delete( folder ) if Dir.exists? folder
					end # each folder
					@expected[:files].each do | file |
						File.delete( file ) if FileTest.exists? file
					end # each file
					Dir.delete( @root ) if Dir.exists? @root
				end # after
				it "should skip the ones that don't need creating and do only what is needed" do
					Raxe::Installer.make_content
					@expected.each do | type, items |
						items.each do |item|
							FileTest.exists?( item ).should be_true
						end # each item
					end # expected each
				end # it
			end # some stuff exists			
		end # folder installation
	end # Raxe::Installer
end # Raxe
