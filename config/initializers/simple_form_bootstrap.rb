# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.input_class = "form-control"
  config.boolean_style = :nested
  config.wrappers :bootstrap, tag: 'div', class: 'form-group control-group', error_class: 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.use :input
    b.use :error, :wrap_with => { :tag => 'span', :class => 'help-inline' }
    b.use :hint,  :wrap_with => { :tag => 'p', :class => 'help-block' }
  end

  # config.wrappers :prepend, :tag => 'div', :class => "input-group", :error_class => 'error' do |b|
  #   b.use :html5
  #   b.use :placeholder
  #   b.use :label
  #   b.wrapper :tag => 'div', :class => 'form-controls' do |input|
  #     input.wrapper :tag => 'div', :class => 'input-prepend' do |prepend|
  #       prepend.use :input
  #     end
  #     input.use :hint,  :wrap_with => { :tag => 'span', :class => 'help-block' }
  #     input.use :error, :wrap_with => { :tag => 'span', :class => 'help-inline' }
  #   end
  # end

  # config.wrappers :append, :tag => 'div', :class => "input-group", :error_class => 'error' do |b|
  #   b.use :html5
  #   b.use :placeholder
  #   b.use :label
  #   b.wrapper :tag => 'div', :class => 'form-controls' do |input|
  #     input.wrapper :tag => 'div', :class => 'input-append' do |append|
  #       append.use :input
  #     end
  #     input.use :hint,  :wrap_with => { :tag => 'span', :class => 'help-block' }
  #     input.use :error, :wrap_with => { :tag => 'span', :class => 'help-inline' }
  #   end
  # end

  # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
  # Check the Bootstrap docs (http://twitter.github.com/bootstrap)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :bootstrap
end
