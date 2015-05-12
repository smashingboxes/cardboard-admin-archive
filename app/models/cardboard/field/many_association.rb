module Cardboard
  class Field::ManyAssociation < Field
    serialize :value_uid, Array

    def association_hash
      @association_type ||= begin
        template = if object_with_field_type == "Cardboard::Page"
          page_part = object_with_field
          page_part.page.template[page_part.identifier]
        else
          object_with_field.template
        end
        template[self.identifier][:association]
      end
    end

    def value=(ids)
      if ids.is_a? String
        ids = ids.split(",").map{|x| x.to_i}.reject(&:blank?)
      end
      self.value_uid = ids
    end

    # def value
    #   association_hash[:class].constantize.find(value_uid)
    # end

    def all_options
      association_hash[:class].constantize.pluck(association_hash[:field], :id)
    end

  end
end
