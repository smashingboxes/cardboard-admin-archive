class AddRichTextToPianos < ActiveRecord::Migration
  def change
    add_column :pianos, :rich_text, :text
  end
end
