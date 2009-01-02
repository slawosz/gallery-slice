require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Photo do

  it "new photo should has be marked as new" do
    photo = Photo.create
    photo.new.should == true
  end

  it "after describing photos shouldnt be marked as new and should has description" do
    photo = Photo.create
    photo_hash = { photo.id.to_sym => { :description => "aaa", :title => "bbb" }}
    Photo.describe(photo_hash)
    photo.new.should == false
    photo.title.should == "bbb"
    photo.description.should == "aaa"
  end

end
