# This migration comes from cardboard (originally 20130206192253)
class CreateCardboardDocuments < ActiveRecord::Migration
  def change
    create_table :cardboard_documents do |t|
      t.string :title
      t.string :url
      t.references :collection
      t.text :fields_value

      t.timestamps
    end
    add_index :cardboard_documents, :collection_id
  end
end
