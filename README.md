# Cardboard

## Installation

Add the gem to the gemfile
```
gem 'cardboard'
bundle install
```

Run the generator
```
rails g cardboard:install
rake db:migrate
```

Edit your `config/cardboard.yml` file then run
```
rake db:seed
```


## Usage

### Fetch a page part
```ruby
current_page.get("slideshow")
```
Get returns an active record collection. 
This means that regular Rails methods such as `where`, `limit`, `first`, `each`, etc can be used on page parts

### Fetch a repeatable page part
```ruby
- current_page.get("slideshow").each do |slide| 
  p= image_tag slide.attr("image1").thumb("600x300").url, alt: slide.attr("description")
```
### Fetch a single field
```ruby
current_page.get("intro").attr("text1")
```
<!-- Or
```ruby
@page.get("slideshow").fetch("pepople_count > 5")
``` -->

If this part is **not repeatable** you can use the shorthand notation
```ruby
current_page.get("intro.text1")
```


### Image Fields methods
Images returned by `current_page.get("intro.image1")` are Dragonfly objects. As such, it's possible to edit them directly from the view.

```ruby
image.url                 # => URL of the modified image
image.thumb('40x30').url  # same as image.process(:thumb, '40x30')

#thumb options
'400x300'            # resize, maintain aspect ratio
'400x300!'           # force resize, don't maintain aspect ratio
'400x'               # resize width, maintain aspect ratio
'x300'               # resize height, maintain aspect ratio
'400x300>'           # resize only if the image is larger than this
'400x300<'           # resize only if the image is smaller than this
'50x50%'             # resize width and height to 50%
'400x300^'           # resize width, height to minimum 400,300, maintain aspect ratio
'2000@'              # resize so max area in pixels is 2000
'400x300#'           # resize, crop if necessary to maintain aspect ratio (centre gravity)
'400x300#ne'         # as above, north-east gravity
'400x300se'          # crop, with south-east gravity
'400x300+50+100'     # crop from the point 50,100 with width, height 400,300
```

More options (also see http://markevans.github.io/dragonfly/file.ImageMagick.html):
```ruby
image.width               # => 280
image.height              # => 355
image.aspect_ratio        # => 0.788732394366197
image.portrait?           # => true
image.landscape?          # => false
image.depth               # => 8
image.number_of_colours   # => 34703
image.format              # => :png
image.image?              # => true - will return true or false for any content
image.process(:flip)                         # flips it vertically
image.process(:flop)                         # flips it horizontally
image.process(:greyscale, :depth => 128)     # default depth 256
image.process(:rotate, 45, :background_colour => 'transparent')   # default bg black
```


## Customization

### Pages
To add pages to cardboard edit `config/cardboard.yml`

```
pages:
  home_page:
    title: Default page title
    parts:
      slideshow:
        repeatable: true
        fields:
          image1:
            type: image
            required: true
            position: 0
```
pages, parts and fields take identifiers (home_page, slideshow and image1) used to reference the data form the views. Choose these names carefully!

#### pages_identifiers
`title:`, `parts:`, `position:`(lowest position is the root page)
####parts_identifiers
`fields:`, `position:`
####fields_identifiers
`label:`, `type:`, `required:`(default == true), `position:`, `default:`(except files and images), `hint:`, `placeholder`, `value` (will overwrite user input, use `default` instead)

Allowed field types are:
```
boolean
date
decimal
external_link (needs value: http://site.com)
file
image
integer
resource_link (needs value: resource_linked)
rich_text
string
```

### Resources
To add an admin area for a model simply type (make sure the model exists first)
```
rails g cardboard:resource model_name
```

Then customize the `controllers/cardboard/model_name_controller.rb` and associated views to your heart's desire


### Settings
You can create new settings that will be editable from the admin panel. 

In your `config/cardboard.yml`

```
settings:
  my_custom_setting:
    type: boolean
    default: true
```
all options/types from fields are available

Then you can use this setting in your views or controllers like so:
```ruby
Cardboard::Setting.my_custom_setting
```

## View Helpers
### Page
```ruby
current_page
```
### Meta tags
```ruby
= meta_and_title(@page)
```
### Show edit link
```ruby
- if current_admin_user && @page
  div style="float:right;background:#CCC;padding:8px;"
    = link_to "Edit this page", cardboard.edit_page_path(current_page)
```
### Page nav
```ruby
= nested_pages do |page, subpages|
  .indent
    = link_to(page.title, page.url) if page.in_menu?
    = subpages
```
or similarly with UL and LI tags
```ruby
ul
  = nested_pages do |page, subpages|
    li
      = link_to(page.title, page.url) if page.in_menu?
      ul= subpages
```

## Troubleshoot
### IO Error
There is a known conflict with gem `meta_request`. Please remove this gem until this issue has been resolved:
https://github.com/dejan/rails_panel/issues/51

## License
This project rocks and uses MIT-LICENSE.