# Cardboard

## Installation
```
 rake Cardboard:install:migrations
 rake Cardboard:install:assets
 rake db:migrate
 rake db:seed
```

Add to the BOTTOM of your routes file

```ruby
mount Cardboard::Engine => "/"
```

## Customization

=== Settings
You can create new settings that will be editable from the admin panel. 

```
app
|- models
  |- cardboard
    |- setting.rb
```

```ruby
Cardboard::Setting.create(name: "my_custom_setting", default_value: "something", format: "string")
```

Then you can use this setting in your views or controllers like so:
```ruby
Cardboard::Setting.my_custom_setting
```


== Usage

=== Images

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
image.jpg                         # same as image.encode(:jpg)
image.png                         # same as image.encode(:png)
image.gif                         # same as image.encode(:gif)
image.strip                       # same as image.process(:strip)
image.convert('-scale 30x30')     # same as image.process(:convert, '-scale 30x30')

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
== License
This project rocks and uses MIT-LICENSE.