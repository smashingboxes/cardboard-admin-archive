class RichTextInput < SimpleForm::Inputs::TextInput
  def input
    # input_html_options[:class] += [:wysihtml5] #now using the .rich_text default tag
    @builder.text_area(attribute_name, input_html_options)
  end
end