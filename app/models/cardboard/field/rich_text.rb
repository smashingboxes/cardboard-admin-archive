module Cardboard
  class Field::RichText < Field
    validates :value, presence:true, :if => :required_field?
    before_save :sanitize_value



    def default
      "<div><h2><span>What is Lorem Ipsum?</span></h2><p><strong>Lorem Ipsum</strong> is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.</p></div>"
    end

    private
    
    def sanitize_value
      return nil unless value_changed?
      self.value = ActionController::Base.helpers.sanitize(self.value, :tags => %w(strong b i em br p div span ul ol li a pre code blockquote h1 h2 h3), :attributes => %w(class style href src width height alt))
    end
  end
end