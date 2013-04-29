class DateInput < SimpleForm::Inputs::StringInput
  def input
    input_html_options[:class] |= ["datepicker"]
    super
  end

end


