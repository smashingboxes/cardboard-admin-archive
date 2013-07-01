class DatePickerInput < SimpleForm::Inputs::StringInput
  def input
    input_html_options[:class] |= ["datepicker"]
    input_html_options[:type] = "text"
    super
  end

end


