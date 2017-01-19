# AuditTables

[![CircleCI](https://circleci.com/gh/syncordiahealth/audit_tables/tree/master.svg?style=shield)](https://circleci.com/gh/syncordiahealth/audit_tables/tree/master)

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/audit_tables`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'audit_tables'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install audit_tables

## Usage

You'll need to set up the tables that you don't want to audit in `config/initializers/audit_tables.rb`. Here is a possible configuration for this file:

```ruby
AuditTables.configure do |config|
  config.exclude_tables << 'users'
  config.exclude_tables << 'countries'
  config.exclude_tables << 'cities'
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/syncordiahealth/audit_tables.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
