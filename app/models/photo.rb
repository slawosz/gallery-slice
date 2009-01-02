class Photo
  include DataMapper::Resource
  include Paperclip::Resource
  
  property :id, Serial
  property :file_file_name, String
  property :file_content_type, String
  property :file_file_size, Integer
  property :file_updated_at, DateTime
  property :gallery_id, Integer
  property :title, String
  property :description, Text
  property :new, TrueClass, :default => true
  
  has_attached_file :file, :styles => { :huge => "800x800>", :big => "600x600>", :medium => "300x300>", :thumb => "100x100>", :tiny => "50>x50>" }

  belongs_to :gallery

  def self.describe(hash)
    hash.each do |k,v|
      get(k.to_i).update_attributes(v.merge({ :new => false }) )
    end
  end


  def previous_photo_path
    previous_photo.file(:thumb)
  rescue
    ""
  end

  def next_photo_path
    next_photo.file(:thumb)
  rescue
    ""
  end

  def previous_photo_id
    self.previous_photo.id
  rescue  
   ""
  end

  def next_photo_id
    self.next_photo.id
  rescue
    ""
  end

  #protected

  def previous_photo
    Photo.first( :id.lt => self.id, :gallery_id => self.gallery_id, :order => [:id.desc] )
  end

  def next_photo
    Photo.first( :id.gt => self.id, :gallery_id => self.gallery_id, :order => [:id.asc] )
  end

end
