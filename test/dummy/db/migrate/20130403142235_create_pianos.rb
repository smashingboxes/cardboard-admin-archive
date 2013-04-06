class CreatePianos < ActiveRecord::Migration
  def change
    create_table :pianos do |t|
      t.string :name
      t.string :image

      t.timestamps
    end
  end
end
