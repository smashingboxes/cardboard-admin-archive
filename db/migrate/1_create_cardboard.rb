class CreateCardboard < ActiveRecord::Migration
  def change
    #Fields
    create_table :cardboard_fields do |t|
      t.string :identifier
      t.string :type
      t.text :value_uid
      t.integer :object_with_field_id
      t.string :object_with_field_type

      t.timestamps
    end
    add_index :cardboard_fields, :identifier
    add_index :cardboard_fields, [:object_with_field_id, :object_with_field_type], :name => 'parent_object'

    #Page Parts
    create_table :cardboard_page_parts do |t|
      t.string :identifier
      t.integer :position
      t.belongs_to :page

      t.timestamps
    end
    add_index :cardboard_page_parts, :page_id
    add_index :cardboard_page_parts, :identifier

    #Pages
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

    #Settings
    create_table :cardboard_settings do |t|
      t.string :name
      t.text :value
      t.text :default_value
      t.text :template

    end
    add_index :cardboard_settings, :name

    #Templates
    create_table :cardboard_templates do |t|
      t.string :name
      t.text :fields
      t.string :identifier
      t.boolean :is_page
      t.timestamps
    end
  end
end
