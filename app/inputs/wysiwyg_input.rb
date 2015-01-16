class WysiwygInput < SimpleForm::Inputs::TextInput
  def input(wrapper_options = nil)
    input_html_options[:class] += [:wysihtml5]
    input_html_options[:'data-no-turbolink'] = true
    @builder.input_field(attribute_name, input_html_options)
  end
end
