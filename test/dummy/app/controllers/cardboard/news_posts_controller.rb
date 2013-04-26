
class Cardboard::NewsPostsController < Cardboard::AdminController
  inherit_resources

  def self.icon
    "icon-file-alt"
  end
end