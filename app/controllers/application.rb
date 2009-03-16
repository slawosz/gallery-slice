class GallerySlice::Application < Merb::Controller
  
  controller_for_slice
  protected
   
  def get_model
    Merb::Slices::config[:gallery_slice][:models].each do |model|
      params.each_key do |key|
	return model if key =~ /#{model.to_s.downcase}/
      end
      return Gallery
    end
  end


end
