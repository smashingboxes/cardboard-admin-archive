class RichTextInput < SimpleForm::Inputs::TextInput
  def input(wrapper_options = nil)
    template.render('cardboard/fields/rich_text_toggle', f: @builder, attribute_name: attribute_name)
  end
end
