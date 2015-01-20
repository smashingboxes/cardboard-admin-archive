module Cardboard
  class Field::Image < Field::File
    dragonfly_accessor :value do
      after_assign :resize_image
    end

    validates_property :format, of: :value, in: %w(jpeg jpg png gif), if: :value_uid?
    validates_property :image?, of: :value, as: true, if: :value_uid?
    validates :value, presence:true, if: :required_field?

    def default
      Dragonfly.app.generate :plain, [400, 800].sample, 600, color: '#CCCCCC'
    end

    private

    def resize_image
      self.value.process! :resize, '1920x1080>' if value_uid? # TODO: Max image size?
    end

    protected

    def value_uid_regex
      /^app\/assets\/images/
    end
  end
end
