class CreateCardboardSettings < ActiveRecord::Migration
  def change
    create_table :cardboard_settings do |t|
      t.string :name
      t.text :value
      t.text :default_value
      t.text :template

    end
    add_index :cardboard_settings, :name
  end
end
