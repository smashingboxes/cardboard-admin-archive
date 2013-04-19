module Cardboard
  class Field::Image < Field
    attr_accessible :retained_value, :remove_value
    image_accessor :value 

    before_save :resize_image

    validate :mime_type_is_allowed

    def default
      app = Dragonfly[:images].configure_with(:imagemagick)
      image = app.fetch( Rails.root.join('app', 'assets', 'images', "cardboard", "lorem-ipsum-coffe-mug.jpg"))
      # image = app.generate(:text, "Image",
      #   :font_size => 30,                                 # defaults to 12
      #   :font_family => 'Monaco',
      #   :stroke_color => '#ddd',
      #   # :color => 'red',
      #   :font_style => 'italic',
      #   :font_stretch => 'expanded',
      #   :font_weight => 'bold',
      #   :padding => '200',
      #   :background_color => '#efefef',                   # defaults to transparent
      # )
    end

  private

    def resize_image
      return nil unless self.value && self.value_uid_changed? 
      value.process!(:resize, '1920x1080>')  #max image size 
    end

    def mime_type_is_allowed
      return nil unless self.value
      allowed_mime = ["image/png", "image/jpeg", "image/gif"] #TODO: make editable via settings
      errors.add(:value, "is not a valid image type (.png, .jpeg, .gif)") unless allowed_mime.include?(value.mime_type)
    end
  end
end