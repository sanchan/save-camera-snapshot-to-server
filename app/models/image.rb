class Image < ActiveRecord::Base
  attr_accessible :cover_image
  image_accessor :cover_image
  
  def as_json(arg)
    {url: cover_image.url}
  end
end
