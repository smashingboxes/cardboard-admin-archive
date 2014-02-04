class CreateCardboardTemplates < ActiveRecord::Migration
  def change
    create_table :cardboard_templates do |t|
      t.string :name
      t.text :fields
      t.string :identifier

      t.timestamps
    end
  end
end
