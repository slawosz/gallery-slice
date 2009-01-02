class GallerySlice::Galleries < GallerySlice::Application
  
  # GET /galleries
  def index
    @galleries = Gallery.all
    render
  end

  # GET /galleries/:id
  def show
    @gallery = Gallery.get params[:id]
    render
  end

  # GET /galleries/new
  def new
    @gallery = Gallery.new
    render
  end

  # GET /galleries/:id/edit
  def edit
    @gallery = Gallery.get(params[:id])
    render
  end

  def edit_photos
    @gallery = Gallery.get(params[:id])
    @photos = @gallery.new_photos
    render
  end

  # GET /galleries/:id/delete
  def delete
    render
  end

  # POST /galleries
  def create
    @gallery = Gallery.new(params[:gallery])
    if @gallery.save
      @gallery.add_photos(params[:photos])
      redirect slice_url(:edit_photos_gallery, @gallery), :message => {:notice => "Gallery succesfully added"}
    else
      message[:error] = "Nie udalo sie dodac galerii"
      render :new
    end	
  end

  # PUT /galleries/:id
  def update
    @gallery = Gallery.get(params[:id])
    unless params[:gallery].blank?
      if @gallery.update_attributes(params[:gallery] )
        redirect slice_url(:edit_photo_gallery,@gallery), :message => {:notice => "Gallery succesfully updated"}
      else
        message[:error] = "Error in gallery edit"
        render :new
      end	
    else
      Photo.describe(params[:photos])
      redirect slice_url(:gallery,@gallery), :message => {:notice => "Photos succesfully updated"}
    end
  end

  # DELETE /galleries/:id
  def destroy
    render
  end

	
end
