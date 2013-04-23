# Gazelle

This gem is a wrapper around the what.cd Gazelle API.

## Installation

Add this line to your application's Gemfile:

    gem 'gazelle'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gazelle

## Usage

Include this at the beginning of your file.
```ruby
require 'gazelle'
include RubyGazelle
```

Connect with this:
```ruby
Gazelle.connect({username: "username", password: "password"})
```

Further documentation to come. Glance in the code to see the methods, all pretty self explanatory.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
