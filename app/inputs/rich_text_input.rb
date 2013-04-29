class RichTextInput < SimpleForm::Inputs::TextInput
  #now using the .rich_text default tag instead (ie: yes, we need this file...)
  # def input
  #   input_html_options[:class] += [:wysihtml5] 
  #   @builder.text_area(attribute_name, input_html_options)
  # end
end