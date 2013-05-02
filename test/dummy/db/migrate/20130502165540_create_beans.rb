class CreateBeans < ActiveRecord::Migration
  def change
    create_table :beans do |t|
      t.string :color
      t.string :flavor
      t.boolean :from_mexico
      t.integer :size

      t.timestamps
    end
  end
end
