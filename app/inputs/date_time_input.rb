class DateTimeInput < SimpleForm::Inputs::DateTimeInput
  def input
    # added for http://silviomoreto.github.io/bootstrap-select/
    input_html_options["data-width"] = "auto"
    super
  end
end