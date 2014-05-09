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
      t.integer :position
      t.text :meta_seo
      t.boolean :in_menu, default: true
      t.string :identifier, unique: true
      t.belongs_to :template

      t.timestamps
    end
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
      t.string :controller_action
      t.timestamps
    end
    add_index :cardboard_templates, :identifier, :unique => true

    create_table :cardboard_urls do |t|
      t.string :slug, index: true
      t.string :path, index: true
      t.text :slugs_backup
      t.text :meta_tags
      t.references :urlable,  polymorphic: true

      t.timestamps
    end
    add_index :cardboard_urls, [:path, :slug], :unique => true
  end
end
