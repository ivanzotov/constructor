module ConstructorPages
  class Image < ActiveRecord::Base
    attr_accessible :image, :page_id
    belongs_to :page
    
    image_accessor :image 
  
    validates :image, :presence  => true
    validates_size_of :image, :maximum => 5.megabytes, :message => :incorrect_size
    validates_property :mime_type, :of => :image, :in => %w(image/jpeg image/png image/gif), :message => :incorrect_format    
  end
end