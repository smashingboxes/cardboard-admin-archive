class CreateCardboardPageParts < ActiveRecord::Migration
  def change
    create_table :cardboard_page_parts do |t|
      t.string :identifier
      t.integer :position
      t.integer :parent_part_id
      t.boolean :repeatable
      t.string :label
      t.belongs_to :page

      t.timestamps
    end
    add_index :cardboard_page_parts, :page_id
    add_index :cardboard_page_parts, :identifier
    add_index :cardboard_page_parts, :parent_part_id
  end
end
