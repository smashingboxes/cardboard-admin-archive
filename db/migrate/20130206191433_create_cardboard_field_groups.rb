class CreateCardboardFieldGroups < ActiveRecord::Migration
  def change
    create_table :cardboard_field_groups do |t|
      t.string :name
      t.integer :position
      t.integer :editable_form_id
      t.string :editable_form_type

      t.timestamps
    end
    add_index :cardboard_field_groups, :editable_form_id
  end
end
