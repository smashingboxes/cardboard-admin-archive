# Cardboard

## Dependencies
Make sure you have a authentication solution installed and working. As an example, here is what you need to do to get `Devise` installed.

https://github.com/plataformatec/devise#getting-started

Also make sure you have `imagemagick` installed (on mac do `brew install imagemagick`)

## Installation
Add the gem to the `Gemfile`

```ruby
gem 'cardboard-cms', git: 'git@github.com:smashingboxes/cardboard.git', require: 'cardboard'
```

And run `bundle install`. 

Run the generator to install cardboard and it's migrations:
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

### Fetch a repeatable page part
Repeatable parts returns an active record collection. This means that regular Rails methods such as `where`, `limit`, `first`, `each`, etc can be used on page parts
```slim
- current_page.get('slideshow').each do |slide| 
  p= image_tag slide.attr('image1').thumb('600x300').url, alt: slide.attr('description')
```
### Fetch a single field
If this part is **not repeatable** you can use both
```ruby
current_page.get('intro').attr('text1')
```
Or
```ruby
current_page.get('intro.text1')
```
### Image Fields methods
Images returned by `current_page.get('intro.image1')` are [Dragonfly](http://markevans.github.io/dragonfly/) objects. As such, it's possible to edit them directly from the view.

```ruby
image.url                 # => URL of the modified image
image.thumb('40x30#').url  # same as image.process(:thumb, '40x30')
```
More options and methods are available at [Dragonfly's Documentation](http://markevans.github.io/dragonfly/file.ImageMagick.html)


### File field methods
Similarly to images, files are also Dragonfly objects. This allows such methods as:

```ruby
file.format              # => :pdf
file.name                # => "some.pdf"
number_to_human_size(file.size) # => "486 KB"
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
            default: app/assets/images/CrashTest.jpg
            position: 0
```

pages, parts and fields take identifiers (home_page, slideshow and image1) used to reference the data form the views. Choose these names carefully!

#### pages
key: page identifier
value: `title`, `parts`, `position`(lowest position is the root page)
####parts
key: part identifier
value: `fields`, `position`
####fields
key: field identifiers
value: `label`, `type`, `required`(default == true), `position`, `default`, `hint`, `placeholder`, `value` (will overwrite user input, use `default` instead)

Allowed field Types are:

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
= cardboard_filters User, :name, [[:post_name, :string],[:post_size, :integer]]
```

#### Pagination Helper
We use kaminari, so all you need to do is add
```ruby
= paginate @users
```
to your index view

#### Column sorting helper
Cardboard's controller inherit from a `@q` variable which gives access to the ransack gem. 
```
= sort_link @q, :name, "Product Name" 
```

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

## View
### Page
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
def page_identifier
  @example = "cool"
end
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

## Abilities
You can (and should) add a `can_manage_cardboard` method to your user model. By default users can manage all areas of the admin panel.
```ruby
def can_manage_cardboard?(area)
  case area
  when :pages
    self.admin?
  when :settings
    self.admin?
  when :resource_identifier
    true
  else
    true
  end
end
```
   

## Troubleshoot
### IO Error
There is a known conflict with gem `meta_request`. Please remove this gem until this issue has been resolved:
https://github.com/dejan/rails_panel/issues/51

## Gems used
Cardboard is build on the shoulders of giants
[InheritedResources](https://github.com/josevalim/inherited_resources) | Inherited Resources speeds up development by making your controllers inherit all restful actions so you just have to focus on what is important.
[Simple Form](https://github.com/plataformatec/simple_form) | Forms made easy! It's tied to a simple DSL, with no opinion on markup.
[Kaminari](https://github.com/amatsuda/kaminari) | A Scope & Engine based, clean, powerful, customizable and sophisticated paginator
[Ransack](https://github.com/ernie/ransack) | Object-based searching and filtering

## License
This project rocks and uses MIT-LICENSE.
