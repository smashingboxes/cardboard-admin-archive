# This migration comes from cardboard (originally 20130401180043)
class CreateCardboardSettings < ActiveRecord::Migration
  def change
    create_table :cardboard_settings do |t|
      t.string :name
      t.text :value
      t.text :default_value
      t.text :description
      t.string :hint
      t.string :format, default: "string"

    end
    add_index :cardboard_settings, :name
  end
end
