require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Gallery do

  #before do
    
  #end
  
  it "should create gallery with title" do
    gallery = Gallery.new
    gallery.name = "title"
    gallery.save.should == true 
  end

  it "should create gallery with all attributes" do
    gallery = Gallery.new
    gallery.name = "title"
    gallery.description = "description"
    gallery.save.should == true 
    gallery.name.should == "title"
    gallery.description.should == "description"
    gallery.created_at.should_not be_nil    
    gallery.id.should_not be_nil
    gallery.updated_at.should_not be_nil
  end

  it "should not create gallery without title" do
    gallery = Gallery.new
    gallery.save.should == false
  end

  it "should get new photos" do
    gallery = Gallery.create( :name => "test" )
    photos = []
    for i in [1..5] do
      photos[i] = Photo.create( :title => i, :description => i, :gallery_id => gallery.id )
    end
    gallery.new_photos.each do |p|
      gallery.new_photos.include?(p).should == true
    end
  end

  it "should add new photos" do
    gallery = Gallery.create( :name => "test" )
    photos = ["aa","bb"]
    gallery.add_photos(photos)
    gallery.photos.length.should == 2
  end


  #TODO:
  #write all boring tests (for  edit, delete, etc)

end
