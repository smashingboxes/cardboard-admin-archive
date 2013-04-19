class CreateCardboardFields < ActiveRecord::Migration
  def change
    create_table :cardboard_fields do |t|
      t.string :identifier
      t.string :label
      t.string :type
      t.boolean :required
      t.belongs_to :page_part
      t.integer :position
      t.text :value_uid
      t.string :hint
      t.string :placeholder

      t.timestamps
    end
    add_index :cardboard_fields, :identifier
    add_index :cardboard_fields, :page_part_id
  end
end
