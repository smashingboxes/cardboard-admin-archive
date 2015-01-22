class CreatePianos < ActiveRecord::Migration
  def change
    create_table :pianos do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
