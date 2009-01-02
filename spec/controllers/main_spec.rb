require File.dirname(__FILE__) + '/../spec_helper'

describe "GallerySlice::Main (controller)" do
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { add_slice(:GallerySlice) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should have access to the slice module" do
    controller = dispatch_to(GallerySlice::Main, :index)
    controller.slice.should == GallerySlice
    controller.slice.should == GallerySlice::Main.slice
  end
  
  it "should have an index action" do
    controller = dispatch_to(GallerySlice::Main, :index)
    controller.status.should == 200
    controller.body.should contain('GallerySlice')
  end
  
  it "should work with the default route" do
    controller = get("/gallery-slice/main/index")
    controller.should be_kind_of(GallerySlice::Main)
    controller.action_name.should == 'index'
  end
  
  it "should work with the example named route" do
    controller = get("/gallery-slice/index.html")
    controller.should be_kind_of(GallerySlice::Main)
    controller.action_name.should == 'index'
  end
    
  it "should have a slice_url helper method for slice-specific routes" do
    controller = dispatch_to(GallerySlice::Main, 'index')
    
    url = controller.url(:gallery_slice_default, :controller => 'main', :action => 'show', :format => 'html')
    url.should == "/gallery-slice/main/show.html"
    controller.slice_url(:controller => 'main', :action => 'show', :format => 'html').should == url
    
    url = controller.url(:gallery_slice_index, :format => 'html')
    url.should == "/gallery-slice/index.html"
    controller.slice_url(:index, :format => 'html').should == url
    
    url = controller.url(:gallery_slice_home)
    url.should == "/gallery-slice/"
    controller.slice_url(:home).should == url
  end
  
  it "should have helper methods for dealing with public paths" do
    controller = dispatch_to(GallerySlice::Main, :index)
    controller.public_path_for(:image).should == "/slices/gallery-slice/images"
    controller.public_path_for(:javascript).should == "/slices/gallery-slice/javascripts"
    controller.public_path_for(:stylesheet).should == "/slices/gallery-slice/stylesheets"
    
    controller.image_path.should == "/slices/gallery-slice/images"
    controller.javascript_path.should == "/slices/gallery-slice/javascripts"
    controller.stylesheet_path.should == "/slices/gallery-slice/stylesheets"
  end
  
  it "should have a slice-specific _template_root" do
    GallerySlice::Main._template_root.should == GallerySlice.dir_for(:view)
    GallerySlice::Main._template_root.should == GallerySlice::Application._template_root
  end

end