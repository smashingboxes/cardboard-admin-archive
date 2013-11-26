module Cardboard
  class Field::Image < Field

    dragonfly_accessor :value do 
      after_assign  :resize_image 
    end

    validates_property :format, :of => :value, :in => [:jpeg, :jpg, :png, :gif], if: :value_uid?
    validates_property :image?, :of => :value, :as => true, if: :value_uid?
    validates :value, presence:true, :if => :required_field?

    def default
      # Dragonfly.app.generate(:plasma, [400, 800].sample, 600) 
      Dragonfly.app.generate(:plain, [400, 800].sample, 600, :color => '#CCCCCC')
    end

    def default=(val)
      self.value = Rails.root.join(val) if self.value_uid.nil? && val.present?
    end

  private

    def resize_image
      self.value.process!(:resize, '1920x1080>') if value_uid? #max image size 
    end

  end
end