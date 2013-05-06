# Cardboard

## Installation

Add the gem to the `Gemfile`

```ruby
gem 'cardboard-cms', git: 'git@github.com:smashingboxes/cardboard.git', require: 'cardboard'
```

And `bundle install`. Run the generator

```sh
rails g cardboard:install
rake db:migrate
```

Edit your `config/cardboard.yml` file then run

```sh
rake db:seed
```


## Usage

### Fetch a page part
```ruby
current_page.get('slideshow')
```
Get returns an active record collection. This means that regular Rails methods such as `where`, `limit`, `first`, `each`, etc can be used on page parts

### Fetch a repeatable page part
```slim
- current_page.get('slideshow').each do |slide| 
  p= image_tag slide.attr('image1').thumb('600x300').url, alt: slide.attr('description')
```
### Fetch a single field
```ruby
current_page.get('intro').attr('text1')
```
If this part is **not repeatable** you can use the shorthand notation

```ruby
current_page.get('intro.text1')
```
### Image Fields methods
Images returned by `current_page.get('intro.image1')` are [Dragonfly](http://markevans.github.io/dragonfly/) objects. As such, it's possible to edit them directly from the view.

```ruby
image.url                 # => URL of the modified image
image.thumb('40x30').url  # same as image.process(:thumb, '40x30')
```
More options and methods are available at [Dragonfly's Documentation](http://markevans.github.io/dragonfly/file.ImageMagick.html)


### File field methods
Similarly to images, files are also Dragonfly objects. This allows such methods as:

```ruby
file.format              # => :doc
image.image?             # => false
```

## Customization
### Pages
To add pages to cardboard edit `config/cardboard.yml`. See an sample `cardboard.yml` in [https://github.com/smashingboxes/cardboard/blob/master/test/dummy/config/cardboard.yml](https://github.com/smashingboxes/cardboard/blob/master/test/dummy/config/cardboard.yml)

```yml
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
`title`, `parts`, `position`(lowest position is the root page)
####parts_identifiers
`fields`, `position`
####fields_identifiers
`label`, `type`, `required`(default == true), `position`, `default`(except files and images), `hint`, `placeholder`, `value` (will overwrite user input, use `default` instead)

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

```sh
rails g cardboard:resource model_name
```

Then customize the `controllers/cardboard/model_name_controller.rb` and associated views to your heart's desire


### Settings
You can create new settings that will be editable from the admin panel. 

In your `config/cardboard.yml`

```yml
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
```slim
= meta_and_title(current_page)
```
### Show edit link
Feel free to make it fit as you want in your site design
```slim
- if current_admin_user && current_page
  div style="float:right"
    = link_to "Edit this page", cardboard.edit_page_path(current_page)
```
### Page nav
```slim
= nested_pages do |page, subpages|
  .indent
    = link_to(page.title, page.url) if page.in_menu?
    = subpages
```
or similarly with UL and LI tags

```slim
ul
  = nested_pages do |page, subpages|
    li
      = link_to(page.title, page.url) if page.in_menu?
      ul= subpages
```

### Link to a page
Use the page identifier defined in the cardboard.yml file (or see yoda)
```ruby
  link_to_page "page_identifier", class: "btn" do |page|
    "hello #{page.title}"
  end
```
   

## Troubleshoot
### IO Error
There is a known conflict with gem `meta_request`. Please remove this gem until this issue has been resolved:
https://github.com/dejan/rails_panel/issues/51

## License
This project rocks and uses MIT-LICENSE.
