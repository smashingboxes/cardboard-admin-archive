# This migration comes from cardboard (originally 20130206191433)
class CreateCardboardPageParts < ActiveRecord::Migration
  def change
    create_table :cardboard_page_parts do |t|
      t.string :identifier
      t.integer :position
      t.boolean :allow_multiple, default: false
      t.string :label
      t.belongs_to :page

      t.timestamps
    end
    add_index :cardboard_page_parts, :page_id
    add_index :cardboard_page_parts, :identifier
  end
end
