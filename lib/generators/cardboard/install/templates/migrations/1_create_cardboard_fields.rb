class CreateCardboardFields < ActiveRecord::Migration
  def change
    create_table :cardboard_fields do |t|
      t.string :identifier
      t.string :type
      t.text :value_uid
      t.integer :object_with_field_id
      t.string :object_with_field_type

      t.timestamps
    end
    add_index :cardboard_fields, :identifier
    add_index :cardboard_fields, [:object_with_field_id, :object_with_field_type], :name => 'parent_object'
  end
end
