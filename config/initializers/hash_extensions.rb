class Hash

  def filter(*args)
    return nil if args.empty?
    self.select {|key| args.include?(key.to_s) || args.include?(key.to_sym)}
  end
end