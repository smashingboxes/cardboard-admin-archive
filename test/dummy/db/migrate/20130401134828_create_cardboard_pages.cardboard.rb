# This migration comes from cardboard (originally 20130206191721)
class CreateCardboardPages < ActiveRecord::Migration
  def change
    create_table :cardboard_pages do |t|
      t.string :title
      t.string :url
      t.string :slug
      t.integer :position

      t.timestamps
    end
    add_index :cardboard_pages, [:url, :slug], :unique => true
  end
end
