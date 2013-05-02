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
@page.get("slideshow")
```
Get returns an active record collection. 
This means that regular Rails methods such as `where`, `limit`, `first`, `each`, etc can be used on page parts

### Fetch a repeatable page part

### Fetch a single field
```ruby
@page.get("intro").attr("text1")
```
<!-- Or
```ruby
@page.get("slideshow").fetch("pepople_count > 5")
``` -->

If this part is **not repeatable** you can use the shorthand notation
```ruby
@page.get("intro.text1")
```


### Image Fields methods

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

image.thumb('40x30')              # same as image.process(:thumb, '40x30')

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

**pages_identifiers**: `title:`, `parts:`, `position:`(lo)
**parts_identifiers**: `fields:`, `position:`
**fields_identifiers**: `label:`, `type:`, `required:`(default == true), `position:`, `default:`(except files and images), `hint:`, `placeholder`, `value` (will overwrite, use `default` instead)

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
  more_fun:
    type: boolean
    default: true
```
all options/types from fields are available

Then you can use this setting in your views or controllers like so:
```ruby
Cardboard::Setting.my_custom_setting
```

## Troubleshoot
### IO Error
There is a known conflict with gem `meta_request`. Please remove this gem until this issue has been resolved:
https://github.com/dejan/rails_panel/issues/51

## License
This project rocks and uses MIT-LICENSE.