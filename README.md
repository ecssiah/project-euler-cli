# Project Euler CLI

This is a command line interface for browsing the problems archived by Project Euler.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'project_euler_cli'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install project_euler_cli

## Usage

Main Menu:

  r - List recent problems

  l - List archived problems

  s - Search problems

  x - Exit program

Display Page Menu:

 \# - View problem (i.e. Problem 314 = 314)

  n - Next page

  p - Previous page

  g - Go to the page number given after g (i.e. Page 12 = g12)

  x - Exit to main menu

Display Problem Menu:

  b - Back to current page

  x - Exit to main menu

Search Menu:

 \# - View problem (i.e. Problem 217 = 217)

  n - Next page

  p - Previous page

  s - Search again

  x - Exit to main menu

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ecssiah/project_euler_cli.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
