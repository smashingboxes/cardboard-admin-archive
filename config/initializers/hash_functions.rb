class Hash
  # Returns a hash that represents the difference between two hashes.
  #
  #   {1 => 2}.diff(1 => 2)         # => {}
  #   {1 => 2}.diff(1 => 3)         # => {1 => 2}
  #   {}.diff(1 => 2)               # => {1 => 2}
  #   {1 => 2, 3 => 4}.diff(1 => 2) # => {3 => 4}
  def diff(other)
    # ActiveSupport::Deprecation.warn "Hash#diff is no longer used inside of Rails, and is being deprecated with no replacement."
    dup.
      delete_if { |k, v| other[k] == v }.
      merge!(other.dup.delete_if { |k, v| has_key?(k) })
  end


  def delete_merge!(other_hash)
    other_hash.each_pair do |k,v|
      tv = self[k]
      if tv.is_a?(Hash) && v.is_a?(Hash) && !v.empty? && !tv.empty?
        tv.delete_merge!(v)
      elsif v.is_a?(Array) && tv.is_a?(Array) && !v.empty? && !tv.empty?
        v.each_with_index do |x, i| 
          tv[i].delete_merge!(x)
        end
        self.delete_merge!(other_hash)
      else
        self.delete(k) if self.has_key?(k)
      end
    end
    self
  end


end