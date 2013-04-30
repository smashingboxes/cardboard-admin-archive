class PolymorphicField < ActiveRecord::Migration
  def up
    add_column :cardboard_fields, :object_with_field_id, :integer
    add_column :cardboard_fields, :object_with_field_type, :string
  end

  def down
  end
end
