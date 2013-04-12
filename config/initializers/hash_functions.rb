class Hash
  # # Returns a hash that represents the difference between two hashes.
  # #
  # #   {1 => 2}.diff(1 => 2)         # => {}
  # #   {1 => 2}.diff(1 => 3)         # => {1 => 2}
  # #   {}.diff(1 => 2)               # => {1 => 2}
  # #   {1 => 2, 3 => 4}.diff(1 => 2) # => {3 => 4}
  # def diff(other)
  #   # ActiveSupport::Deprecation.warn "Hash#diff is no longer used inside of Rails, and is being deprecated with no replacement."
  #   dup.
  #     delete_if { |k, v| other[k] == v }.
  #     merge!(other.dup.delete_if { |k, v| has_key?(k) })
  # end


  # # Returns a hash that removes any matches with the other hash
  # #
  # # {a: {b:"c"}} - {:a=>{:b=>"c"}}                   # => {}
  # # {a: [{c:"d"},{b:"c"}]} - {:a => [{c:"d"}, {b:"d"}]} # => {:a=>[{:b=>"c"}]}
  # #
  # def delete_merge!(other_hash)
  #   other_hash.each_pair do |k,v|
  #     tv = self[k]
  #     if tv.is_a?(Hash) && v.is_a?(Hash) && v.present? && tv.present?
  #       tv.delete_merge!(v)
  #     elsif v.is_a?(Array) && tv.is_a?(Array) && v.present? && tv.present?
  #       v.each_with_index do |x, i| 
  #         tv[i].delete_merge!(x)
  #       end
  #       self[k] = tv - [{}]
  #     else
  #       self.delete(k) if self.has_key?(k) && tv == v
  #     end
  #     self.delete(k) if self.has_key?(k) && self[k].blank?
  #   end
  #   self
  # end

  # def delete_merge(other_hash)
  #   deep_copy.delete_merge!(other_hash)
  # end

  # def -(hash)
  #   self.delete_merge(hash)
  # end

  # def deep_copy
  #   Marshal.load(Marshal.dump(self))
  # end

  def filter(*args)
    return nil if args.empty?
    self.select {|key| args.include?(key.to_s) || args.include?(key.to_sym)}
  end
end