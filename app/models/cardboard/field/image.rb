module Cardboard
  class Field::Image < Field
    attr_accessible :remove_value, :retained_value
    image_accessor :value do 
      after_assign  :resize_image 
    end

    validates_property :format, :of => :value, :in => [:jpeg, :jpg, :png, :gif]
    validates_property :image?, :of => :value, :as => true
    validates :value, presence:true, :if => :required_field?

    def default
      # http://stackoverflow.com/a/7115069/454375
      # image = Dragonfly[:images].fetch_file( Cardboard::Engine.root.join('app', 'assets', 'images', "cardboard", "lorem-ipsum-coffe-mug.jpg"))
      # image = Dragonfly[:images].generate(:plasma, 800, 600, :gif) 
      # image = Dragonfly[:images].generate(:plain, 600, 400, '#ccc', :format => :gif)
      image = Dragonfly[:images].generate(:text, "#{self.identifier}",
        :font_stretch => 'expanded',
        :font_weight => 'bold',
        :padding => '30 15',
        :background_color => '#CCC' # defaults to transparent
      )
    end

  private

    def resize_image
      self.value.process!(:resize, '1920x1080>') if value_uid.present? #max image size 
    end

  end
end