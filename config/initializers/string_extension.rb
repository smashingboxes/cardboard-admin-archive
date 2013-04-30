class String
  # def sanitize(options={})
  #   return self if self.blank?
  #   ActionController::Base.helpers.sanitize(self, options)
  # end

  # def strip_tags
  #   return self if self.blank?
  #   ActionController::Base.helpers.strip_tags(self)
  # end
  
  def to_boolean
    return true if self == true || !!(self =~ /(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || !!(self =~ /(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end

  # def make_url_safe
  #   return self if self.blank?
  #   Rack::Utils.escape(self.strip_tags).gsub("+", "%20")
  # end
end