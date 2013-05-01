class CreateIcescreams < ActiveRecord::Migration
  def change
    create_table :icescreams do |t|
      t.string :flavor
      t.integer :deliciousness

      t.timestamps
    end
  end
end
