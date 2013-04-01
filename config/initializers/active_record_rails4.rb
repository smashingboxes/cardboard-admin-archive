class ActiveRecord::Base     
  def self.find_by(hash)
   self.where(hash).first
  end 
  def self.find_by!(hash)
   self.where(hash).first!
  end
  def self.find_or_create_by!(hash)
    self.where(hash).first_or_create!
  end
  def self.find_or_create_by(hash)
    self.where(hash).first_or_create
  end
end