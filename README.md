# Cardboard
[![Code Climate](https://codeclimate.com/github/smashingboxes/cardboard.png)](https://codeclimate.com/github/smashingboxes/cardboard)
[![Build Status](https://travis-ci.org/smashingboxes/cardboard.svg?branch=master)](https://travis-ci.org/smashingboxes/cardboard)
[![Stories in Ready](https://badge.waffle.io/smashingboxes/cardboard.png?label=ready&title=Ready)](https://waffle.io/smashingboxes/cardboard)

Cardboard is a simple CMS Engine for your Rails 4 applications.

## Features
* Build for Rails 4
* Make your site and your admin area the standard rails way (no complex engines)
* Create pages and site settings in seconds
* Repeatable page parts
* Write your views in haml/slim/erb...! (no restrictive DSL or templating language)
* Your customers will love the UI/UX
* Easy to extend and customize
* It's like your favorite admin interface gem just had a baby with a CMS

![alt text](https://github.com/smashingboxes/cardboard/wiki/images/2a.jpg "screenshot1")

## Updating from 0.2 -> 0.3
Some changes were made to the database. Before updating make sure to have a look at the [new migration](https://github.com/smashingboxes/cardboard/blob/master/spec/dummy/db/migrate/20150119175934_create_cardboard.cardboard.rb)

## Requirements
* An authentication solution. For example, [here is what you need to do](https://github.com/plataformatec/devise#getting-started) to get **Devise** installed.
* [ImageMagick](http://www.imagemagick.org/)
* **Rails 4.x** and **Ruby 2.x**

## Installation
Add the gem to the _Gemfile_

```ruby
gem 'cardboard_cms'
```

Run bundler and cardboard's install generator
```sh
bundle install
rails generate cardboard:install
rake db:migrate
```

Edit your _config/cardboard.yml_ file then run
```sh
rake cardboard:seed
```

## Usage
### Get a page
Add a file in your _app/views/pages_ (or _app/views/templates_) with filename matching the identifier of the page. Inside this file you can access the page with:
```ruby
current_page
```

### Fetch a page part
```ruby
current_page.get 'slideshow'
```

### Fetch a repeatable page part
Repeatable parts returns an active record collection. This means that regular Rails methods such as `where`, `limit`, `first`, `each`, etc can be used on page parts
```slim
- current_page.get('slideshow').each do |slide|
  p = image_tag slide.attr('image1').thumb('600x300').url, alt: slide.attr('description') if slide.attr('image1')
```

### Fetch a single field
If this part is **not repeatable** you can use both
```ruby
current_page.get('intro').attr 'text1'
# Or
current_page.get 'intro.text1'
```

### Image Fields methods
Images returned by `:image` type fields are [Dragonfly](http://markevans.github.io/dragonfly/) objects. As such, it's possible to edit them directly from the view.
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
file.format                     # => :pdf
file.name                       # => "some.pdf"
number_to_human_size(file.size) # => "486 KB"
```

## Create Pages
To add pages to cardboard edit _config/cardboard.yml_. See a sample [_cardboard.yml_](https://github.com/smashingboxes/cardboard/blob/master/spec/dummy/config/cardboard.yml)
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
            default: CrashTest.jpg
templates:
  two_column:
    parts:
      main:
        fields:
          body:
            type: rich_text
```

pages, parts and fields take identifiers (`:home_page`, `:slideshow` and `:image1`) used to reference the data form the views. Choose these names carefully!

#### Pages
Each page section starts with the name of it's unique identifier. This name is used to reference the page in the code an thus should not change throughout the life of the project.

Key | Type | Default | Definition
---|--- | ---|---
[parts](#parts) | hash | `nil` |a list of page parts
title | string | identifier | name of the page as shown in the nav bar
position | integer | auto-increment | position of the page on the nav bar (the lowest position is the home page!)
parent_id | string | `nil` | identifier of the parent page (used for nested pages)
controller_action | string | `'pages#identifier'` | go to a specific controller example `'blog#index'`. In that case, the page identifier is passed in the params. If you'd like to still have the current_page goodness, make your controller inherit from `UrlController`

#### Templates
Templates are declared exactly like pages. They allow for the creation of pages directly from the admin interface. One key difference between templates and pages is the location of the view files which will be under _app/views/templates_.

#### Parts
Each part sub-section starts with the name of it's unique identifier. This name is used to reference the part in the code an thus should not change throughout the life of the project.

Key | Type | Default | Definition
---|--- | ---|---
[fields](#fields) | hash | `nil` | list of fields that make this part's form
position | integer | auto-increment | position of the part on the admin page
repeatable | boolean or string | `false` | can the client add multiple of these parts (example a slide in a slideshow), if a string is passed, `true` is assumed and the string becomes the label for a single part

#### Fields
Each field sub-section starts with the name of it's unique identifier. This name is used to reference the field in the code an thus should not change throughout the life of the project.

Key | Type | Default | Definition
---|--- | ---|---
label | string | identifier | form field label
hint | string | `nil` | form field hint
placeholder | string | `nil` | form field placeholder
position | integer | auto-increment | position of the field within the part (only for the admin area)
required | boolean | `true` | must this field have a value for the form to save
type | string | `'string'` | choose between: `'boolean'`, `'date'`, `'decimal'`, `'file'`, `'image'`, `'integer'`, `'rich_text'`, `'text'`, `'string'`, `'resource_link'` (needs value: resource_linked, same as the controller name ex: `'pianos'`), `'external_link'` (needs value: `'http://site.com'`)
default | string | `nil` | set the value but don't overwrite (only set if `nil`). Put default images in _/assets/images/defaults_ and default files in _/assets/files/defaults_
value | string | `nil` | USE ONLY FOR types `'resource_link'` and `'external_link'` (this will overwrite user input, in most cases use the **_default_** key instead)

## Create Resources
To add an admin area for a model simply type (make sure the model exists first and migrations have been run)
```sh
rails generate cardboard:resource model_name
```

Then customize the _controllers/cardboard/model_name_controller.rb_ and associated views to your heart's desire.

The default cardboard resource scaffold help you quickly get started by making the most of the following gems.

Gem | Description
--- | ---
[Simple Form](https://github.com/plataformatec/simple_form) | Forms made easy! It's tied to a simple DSL, with no opinion on markup.
[Kaminari](https://github.com/amatsuda/kaminari) | A Scope & Engine based, clean, powerful, customizable and sophisticated paginator
[Ransack](https://github.com/activerecord-hackery/ransack) | Object-based searching and filtering
[Dragonfly](https://github.com/markevans/dragonfly) | On-the-fly image processing and file uploading


### Menu options
You can customize the menu for this resource by adding to the controller class:
```ruby
menu  label: 'Test', priority: 1
```

You can also choose to remove a resource from the menu
```ruby
menu  false
```

### Sorting
You can customize the sorting for this resource by adding to the controller class:
```ruby
default_order 'name DESC' # default: 'updated_at desc'
```

You can pass any **Ransack** sort order, which includes associations. Example:
```ruby
default_order 'user_name' # belongs to a user
```

#### Filter helper
You can show filters on your resource index page simply by adding `cardboard_filters`, with the model class, the main field to search (has to be a text or string field), and options.

```ruby
= cardboard_filters User, :name
```

Property | Description
--- | ---
`:title` | change the page's title (optional)
`:new_button` | Options for the button used to create a new resource element. Can be `false` to remove it, or `'label'` and `'url'` can be modified (optional).
`:predicate`|  defaults to `'cont'` (contains). Note: On non text fields, this field is required

Example:
```ruby
= cardboard_filters User, :name, title: 'Employees', new_button: {label: 'Add an employee'}
```

#### Pagination Helper
We use **kaminari**, so all you need to do is add to your index view:
```ruby
= paginate @users
```

#### Column sorting helper
The `@q` variable gives access to the **Ransack** gem.
```
= sort_link @q, :name, 'Product Name'
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
Make sure this file is located under 'app/helpers/cardboard'

#### Custom CSS/JS
The css/js for the resources is the same as the cardboard admin interface. If you'd like to extend or overwrite some of these, simply edit the _cardboard.css.scss_ or _cardboard.js_ files located in your _assets/_ folder. These files were generated during the cardboard installation.

Note: Make sure to remove `*= require_tree .` from your _application.css_, you don't want your cardboard css and js to leak into your main app!

## Create Settings
You can create new settings that will be editable from the admin panel.

In your _config/cardboard.yml_
```yml
settings:
  my_custom_setting:
    type: boolean
    default: true
```

All options/types from fields are available

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
    @example = 'cool'
  end
end
```

### Page Path
In your controllers you may want to redirect to a specific page. You can do so with the following:
```ruby
page_path 'identifier_for_this_page'
page_url 'identifier_for_this_page'
cardboard.edit_page_path @page #link to let your admins edit the page they see
```

### Meta tags (SEO)
To add SEO meta tags simply add a yield as follows to your layout file:
```slim
head
  = yield :seo
```

### Show edit link
Feel free to make it fit as you want in your site design
```slim
- if current_admin_user && current_page
  div style="float:right"
    = link_to 'Edit this page', cardboard.edit_page_path(current_page)
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
        ul = subpages
```

### Link to a page
Use the page identifier defined in the _cardboard.yml_ file
```ruby
= link_to_page 'page_identifier', class: 'btn' do |page|
  "hello #{page.title}"
end

# or, to simply use the page title

= link_to_page 'page_identifier', class: 'btn'
```

## Abilities
You can (and should) add a `can_manage_cardboard?` method to your user model. By default users can manage all areas of the admin panel.
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

## Customizing Cardboard

### Overwrite views
You can easily change the default behavior of the app by overwriting the views. For example say you'd like to change the my account page. Simply add a _views/cardboard/my_account/edit.html.slim_ and edit it at will.

## Deploy with Capistrano
```ruby
namespace :cardboard do
  desc 'Seed the cardboard'
  task :seed do
    run "cd #{current_path}; bundle exec rake cardboard:seed RAILS_ENV=#{rails_env}"
  end
end
after 'deploy', 'cardboard:seed'
```

## License
Copyright (c) 2013-2015 by Smashing Boxes

See [LICENSE.txt](https://github.com/smashingboxes/cardboard/blob/master/LICENSE.txt)
