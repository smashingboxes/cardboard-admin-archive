class CreateCardboardFields < ActiveRecord::Migration
  def change
    create_table :cardboard_fields do |t|
      t.string :identifier
      t.string :label
      t.string :type
      t.boolean :required, default: true
      t.belongs_to :page_part
      t.integer :position
      t.text :value_uid
      t.string :hint
      t.string :placeholder
      t.integer :object_with_field_id
      t.string :object_with_field_type

      t.timestamps
    end
    add_index :cardboard_fields, :identifier
    add_index :cardboard_fields, [:object_with_field_id, :object_with_field_type], :name => 'parent_object'
  end
end
