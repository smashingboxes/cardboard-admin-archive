guard :livereload do
  watch(%r{app/views/.+\.(erb|haml|slim)$})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})
  # Rails Assets Pipeline
  # watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html|png|jpg))).*}) { |m| "/assets/#{m[3]}" }
  # Newsest sass-rails encourages dropping .css from SASS files. This regex
  # supports all .css, .css.scss and .scss variants (css/sass and js/coffee too)
  watch(%r{(app|vendor)\/assets\/\w+\/([\w\/]+)(\.(css|js))?\.(scss|css|coffee|js|png|jpg)}) { |m| "/assets/#{m[2]}.#{convert_extension(m[5])}" }
end

def convert_extension(extension)
  case extension
  when 'sass'
  when 'scss'
    'css'
  when 'coffee'
    'js'
  else
    extension
  end
end
