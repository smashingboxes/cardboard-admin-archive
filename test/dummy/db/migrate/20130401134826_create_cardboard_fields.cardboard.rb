# This migration comes from cardboard (originally 20130206190511)
class CreateCardboardFields < ActiveRecord::Migration
  def change
    create_table :cardboard_fields do |t|
      t.string :element_name
      t.string :display_name
      t.string :type
      t.boolean :required
      t.belongs_to :field_group
      t.integer :position
      t.text :value

      t.timestamps
    end
    add_index :cardboard_fields, :field_group_id
  end
end
