class RichTextInput < SimpleForm::Inputs::TextInput
  def input
    input_html_options[:class] += [:wysihtml5] 
    @builder.text_area(attribute_name, input_html_options)
  end
end