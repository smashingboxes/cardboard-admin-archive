# Cardboard
Cardboard is a simple CMS Engine for your Rails 4 applications.

## Features

* Build for Rails 4
* Make your site and your admin area the standard rails way (no complex engines)
* Create pages and site settings in seconds
* Repeatable page parts
* Write your views in haml/slim/erb...! (no restrictive DSL or templating language)
* Your customers will love the UI/UX
* Super easy to extend and customize
* It's like your favorite admin interface gem just had a baby with a CMS

![alt text](https://github.com/smashingboxes/cardboard/wiki/images/2a.jpg "screenshot1")

## Requirements
* An authentication solution. For example, [here is what you need to do](https://github.com/plataformatec/devise#getting-started) to get `Devise` installed.
* `imagemagick` (on mac do `brew install imagemagick`)
* `Rails 4` and `Ruby 2.0`

## Installation
Add the gem to the `Gemfile`

```ruby
gem "cardboard-cms", github: "smashingboxes/cardboard", require: "cardboard"
gem "inherited_resources", github: "josevalim/inherited_resources"
gem "ransack", github: "ernie/ransack", branch: "rails-4"
```

And run `bundle install`. 

Run the generator to install cardboard and it's migrations:
```sh
rails g cardboard:install
rake db:migrate
```

Edit your `config/cardboard.yml` file then run

```sh
rake cardboard:seed
```


## Usage
### Get a page
Add a file in your `app/views/pages` with filename matching the identifier of the page. Inside this file you can access the page with:
```ruby
current_page
```
### Fetch a page part
```ruby
current_page.get('slideshow')
```

### Fetch a repeatable page part
Repeatable parts returns an active record collection. This means that regular Rails methods such as `where`, `limit`, `first`, `each`, etc can be used on page parts
```slim
- current_page.get('slideshow').each do |slide| 
  p= image_tag slide.attr('image1').thumb('600x300').url, alt: slide.attr('description') if slide.attr('image1')
```
### Fetch a single field
If this part is **not repeatable** you can use both
```ruby
current_page.get('intro').attr('text1')
# Or
current_page.get('intro.text1')
```
### Image Fields methods
Images returned by `image` type fields are [Dragonfly](http://markevans.github.io/dragonfly/) objects. As such, it's possible to edit them directly from the view.

```ruby
if image = current_page.get('intro.image1')
  image.url                 # URL of the modified image
  image.thumb('40x30#').url  # resize, crop if necessary to maintain aspect ratio (centre gravity)
  image.process(:greyscale).thumb('40x30#').url
end # Hint: remember to check if image is not nil before calling methods on it
```
More options and methods are available at [Dragonfly's Documentation](http://markevans.github.io/dragonfly/file.ImageMagick.html)

### File field methods
Similarly to images, files are also Dragonfly objects. This allows such methods as:

```ruby
file.format              # => :pdf
file.name                # => "some.pdf"
number_to_human_size(file.size) # => "486 KB"
```


## Create Pages
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
            default: app/assets/images/CrashTest.jpg
            position: 0
```

pages, parts and fields take identifiers (home_page, slideshow and image1) used to reference the data form the views. Choose these names carefully!

#### Pages
Each page section starts with the name of it's unique identifier. This name is used to reference the page in the code an thus should not change throughout the life of the project.

Key | Type | Default | Definition
---|--- | ---|---
[parts](#parts) | hash | nil |a list of page parts
title | string | identifier | name of the page as shown in the nav bar
position | integer | auto-increment | position of the page on the nav bar (the lowest position is the home page!)
parent_id | string | nil | identifier of the parent page (used for nested pages)


#### Parts
Each part sub-section starts with the name of it's unique identifier. This name is used to reference the part in the code an thus should not change throughout the life of the project.

Key | Type | Default | Definition
---|--- | ---|---
[fields](#fields) | hash | nil | list of fields that make this part's form
position | integer | auto-increment | position of the part on the admin page
repeatable | boolean | false | can the client add multiple of these parts (example a slide in a slideshow) 


####fields
Each field sub-section starts with the name of it's unique identifier. This name is used to reference the field in the code an thus should not change throughout the life of the project.

Key | Type | Default | Definition
---|--- | ---|---
label | string | identifier | form field label
hint | string | nil | form field hint
placeholder | string | nil | form field placeholder
position | integer | auto-increment | position of the field within the part (only for the admin area)
required | boolean | true | must this field have a value for the form to save
type | string | `string` | choose between: `boolean`, `date`, `decimal`, `file`, `image`, `integer`, `rich_text`, `text`, `string`, `resource_link` (needs value: resource_linked), `external_link` (needs value: http://site.com)
default | string | nil | set the value but don't overwrite (only set if nil)
value | string | nil | USE ONLY FOR types `resource_link` and `external_link` (this will overwrite user input, in most cases use the `default` key instead)


## Create Resources
To add an admin area for a model simply type (make sure the model exists first and migrations have been run)

```sh
rails g cardboard:resource model_name
```

Then customize the `controllers/cardboard/model_name_controller.rb` and associated views to your heart's desire.


The default cardboard resource scaffold help you quickly get started by making the most of the following gems. 

Gem | Description 
--- | --- 
[InheritedResources](https://github.com/josevalim/inherited_resources) | Inherited Resources speeds up development by making your controllers inherit all restful actions so you just have to focus on what is important.
[Simple Form](https://github.com/plataformatec/simple_form) | Forms made easy! It's tied to a simple DSL, with no opinion on markup.
[Kaminari](https://github.com/amatsuda/kaminari) | A Scope & Engine based, clean, powerful, customizable and sophisticated paginator
[Ransack](https://github.com/ernie/ransack) | Object-based searching and filtering
[Dragonfly](https://github.com/markevans/dragonfly) | On-the-fly image processing and file uploading


### Menu options
```ruby
  menu  label: "Test", priority: 1
```
You can also choose to remove a resource from the menu
```ruby
  menu  false
```

#### Filter helper
You can show filters on your resource index page simply by adding `cardboard_filters`, with the model class, the main field to search (has to be a text or string field), and options.

```ruby
= cardboard_filters User, :name
```

`fields`: list which field can be filtered. By default all are available.

`title`: change the page's title

`new_btn`: edit the new resource button's text

`associated_fields`: link to associated models 
Example:
```ruby
= cardboard_filters User, :name, associated_fields: [[:post_name, :string],[:post_size, :integer]]
```

#### Pagination Helper
We use kaminari, so all you need to do is add to your index view:
```ruby
= paginate @users
```


#### Column sorting helper
Cardboard's controllers inherit from a `@q` variable which gives access to the ransack gem. 
```
= sort_link @q, :name, "Product Name" 
```

#### Custom resource helpers
To add custom helpers for your resource simply create a helper with the same name. 
Example:
```ruby
module Cardboard
  module PianosHelper
  end
end
```
Make sure this file is located under `app/helpers/cardboard`

#### Custom CSS/JS
The css/js for the resources is the same as the cardboard admin interface. If you'd like to extend or overwrite some of these, simply edit the `cardboard.css.scss` or `cardboard.js` files located in your assets folder. These files were generated during the cardboard installation.

## Create Settings
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
### Access Pages
```ruby
current_page
```

you can put your controller instance variables at the top of your view or in a decorator
```
app
|- decorators
  |- controllers
    |- pages_decorator
```
```ruby
PagesController.class_eval do
  def page_identifier
    @example = "cool"
  end
end
``` 

### Meta tags (SEO)
To add SEO meta tags simply add a yield as follows to your layout file:
```slim
head
 = yield(:seo)
```
### Show edit link
Feel free to make it fit as you want in your site design
```slim
- if current_admin_user && current_page
  div style="float:right"
    = link_to "Edit this page", cardboard.edit_page_path(current_page)
```
### Page navigation
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
      - if subpages
        ul= subpages
```

### Link to a page
Use the page identifier defined in the cardboard.yml file (or see yoda)
```ruby
  link_to_page "page_identifier", class: "btn" do |page|
    "hello #{page.title}"
  end
```

## Abilities
You can (and should) add a `can_manage_cardboard` method to your user model. By default users can manage all areas of the admin panel.
```ruby
def can_manage_cardboard?(area)
  case area
  when :pages
    self.admin?
  when :settings
    self.admin?
  when :resource_identifier #should be plural
    true
  else
    true
  end
end
```

## Dashboard
You can add whatever you want on the dashboard by simply adding
```
views
|- cardboard
   |- dashboard
       |- index.html.slim
```


## License
Copyright (c) 2013 by SmashingBoxes

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
