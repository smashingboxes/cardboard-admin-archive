# This migration comes from cardboard (originally 20130206191918)
class CreateCardboardCollections < ActiveRecord::Migration
  def change
    create_table :cardboard_collections do |t|
      t.string :name
      t.string :url

      t.timestamps
    end
  end
end
