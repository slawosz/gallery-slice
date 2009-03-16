class GallerySlice::GallerySlicePartsPart < Merb::PartController
  controller_for_slice :templates_for => :part, :path => 'views'
  self._template_root = GallerySlice.root / "app" / "parts" / "views"
  def render_photos_form
    render :layout => false
  end

end
