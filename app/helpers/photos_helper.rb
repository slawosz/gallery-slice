module Merb
  module GallerySlice
    module PhotosHelper
    
      def photo_link(photo_path, photo_id, gallery_id, caption)
        unless photo_path.blank?
          ret = "<a href=\"#{ slice_url(:gallery_photo, gallery_id, photo_id)} \"><b>#{caption}</b><br />"
          ret += "<img src=\"#{photo_path}\" /></a>"
        end
      end	
    end
  end 
end # Merb
