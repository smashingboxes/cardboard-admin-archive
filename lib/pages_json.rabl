collection @pages
attributes :id, :title, :parent_id
child(:parts) do
  attributes :name
  child(:fields) do
    attributes :element_name, :display_name, :type, :required
  end 
end
