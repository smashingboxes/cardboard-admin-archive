class CreateCardboardPages < ActiveRecord::Migration
  def change
    create_table :cardboard_pages do |t|
      t.string :title
      t.string :path
      t.string :slug
      t.text :slugs_backup
      t.integer :position
      t.text :meta_seo
      t.boolean :in_menu, default: true
      t.string :identifier, unique: true
      t.belongs_to :template

      t.timestamps
    end
    add_index :cardboard_pages, [:path, :slug], :unique => true
    add_index :cardboard_pages, :identifier, :unique => true
  end
end
