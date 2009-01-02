class GallerySlice::Photos < GallerySlice::Application
  # provides :xml, :yaml, :js

  def index
    @photos = Photo.all
    display @photos
  end

  def show(id)
    @photo = Photo.get(id)
    @gallery = @photo.gallery
    raise NotFound unless @photo
    display @photo
  end

  def new
    only_provides :html
    @photo = Photo.new
    @gallery = Gallery.get(params[:gallery_id])
    display @photo
  end

  def edit(id)
    only_provides :html
    @photo = Photo.get(id)
    raise NotFound unless @photo
    display @photo
  end

  def create(photo)    
    @gallery = Gallery.get params[:gallery_id]
    @gallery.add_photos(params[:photos])
    redirect slice_url(:edit_photos_gallery,@gallery), :message => {:notice => "Photos were succesfully added"}
  end

  def update(id, photo)
    @photo = Photo.get(id)
    @gallery = @photo.gallery
    if @photo.update_attributes( :title => params[:photo][:title], :description => params[:photo][:description], :file => params[:photo][:file])
      #raise "Takie foto: #{@photo.inspect}"
      redirect slice_url(:gallery_photo, @gallery, @photo)
    else
      display @photo, :edit
    end
  end

  def confirm(id)
    @photo = Photo.get(id)
    render
  end

  def delete(id)
    @photo = Photo.get(id)
    gallery = @photo.gallery
    raise NotFound unless @photo
    if @photo.destroy
      redirect slice_url(:gallery, gallery)
    else
      raise InternalServerError
    end
  end

end # Photos
