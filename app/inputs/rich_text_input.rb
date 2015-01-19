class RichTextInput < SimpleForm::Inputs::TextInput
  def input(wrapper_options = nil)
    template.render('cardboard/fields/markdown_with_preview', f: @builder, attribute_name: attribute_name)
  end
end
