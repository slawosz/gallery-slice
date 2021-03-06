if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  dependency 'merb-slices'
  #load_dependency 'merb-slices'
  Merb::Plugins.add_rakefiles "gallery-slice/merbtasks", "gallery-slice/slicetasks", "gallery-slice/spectasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout - the layout to use; defaults to :gallery-slice
  # :mirror - which path component types to use on copy operations; defaults to all
  Merb::Slices::config[:gallery_slice][:layout] ||= :application
  
  # All Slice code is expected to be namespaced inside a module
  module GallerySlice
    
    # Slice metadata
    self.description = "GallerySlice is a chunky Merb slice!"
    self.version = "0.0.1"
    self.author = "slawosz@gmail.com"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(GallerySlice)
    def self.deactivate
    end
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :gallery_slice_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      # example of a named route
      scope.resources :galleries do |gallery|
      	gallery.member :edit_photos, :method => :get
        gallery.resources :photos do |photo|
          photo.member :confirm, :method => :get
        end
        scope.resources :photos do |photo|
          photo.member :confirm, :method => :get
        end
      end

      #scope.match('/index(.:format)').to(:controller => 'main', :action => 'index').name(:index)
      # the slice is mounted at /gallery-slice - note that it comes before default_routes
      #scope.match('/').to(:controller => 'main', :action => 'index').name(:home)
      # enable slice-level default routes by default
      scope.default_routes
    end
    
  end
  
  # Setup the slice layout for GallerySlice
  #
  # Use GallerySlice.push_path and GallerySlice.push_app_path
  # to set paths to gallery-slice-level and app-level paths. Example:
  #
  # GallerySlice.push_path(:application, GallerySlice.root)
  # GallerySlice.push_app_path(:application, Merb.root / 'slices' / 'gallery-slice')
  # ...
  #
  # Any component path that hasn't been set will default to GallerySlice.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  GallerySlice.setup_default_structure!
  
  # Add dependencies for other GallerySlice classes below. Example:
  # dependency "gallery-slice/other"
  
end

module GallerySlicePhotos
  
  def self.included(base)
    base.class_eval do
      include GallerySlicePhotos::InstanceMethods
      extend GallerySlicePhotos::DMClassMethods
    end
  end
  
  module DMClassMethods
    def self.extended(base)
      base.class_eval do
        attr_accessor :photo

        belongs_to :gallery
      	property :gallery_id, Integer

        after :save, :add_photos
      end
    end
  end

  module InstanceMethods 
   
    def new_photos 
      self.photos.all( :new => true )
    end
   
    def photos
      Photo.all( :gallery_id => self.gallery_id )
    end
    
    def add_photos
      if self.gallery.blank?
        g = Gallery.create :name => "gallery for #{self.class} ,#{self.id}"
        self.gallery_id = g.id
        self.save
      else
        self.photo.each do |v|
          Photo.create(:file => v, :gallery_id => self.gallery_id) unless v.blank?
        end
      end
    end

  end

end
