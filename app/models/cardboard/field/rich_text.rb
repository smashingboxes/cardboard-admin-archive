module Cardboard
  class Field::RichText < Field
    validate :is_required
    before_save :sanitize_value

    def value
      self.value_uid.try(:html_safe)
    end

    def default
      "<div><p><strong>Lorem Ipsum</strong> is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.</p></div>".html_safe
    end

    private
    
    def sanitize_value
      return nil unless value_changed?
      self.value = ActionController::Base.helpers.sanitize(self.value, :tags => %w(strong b i u em br p div span ul ol li a pre code blockquote h1 h2 h3), :attributes => %w(class style href src width height alt))
    end

    def is_required
      errors.add(:value, "is required") if required_field? && ActionController::Base.helpers.strip_tags(value_uid).blank?
    end
  end
end