class Gallery
  include DataMapper::Resource
  property :id,          Serial
  property :name,       String
  property :description, Text
  property :created_at,  DateTime
  property :updated_at,  DateTime
  
  has n, :photos
  has 1, :yacht

  validates_present :name

  def add_photos(photos)
    photos.each do |v|
      Photo.create(:file => v, :gallery_id => self.id) unless v.blank?
    end
  end

  def new_photos
    self.photos.all( :new => true )
  end

end
