# AuditTables

[![CircleCI](https://circleci.com/gh/syncordiahealth/audit_tables/tree/master.svg?style=shield)](https://circleci.com/gh/syncordiahealth/audit_tables/tree/master)

The `audit_tables` gem can be used by rails applications using a [postgresql](https://www.postgresql.org/) databases.

It adds helper functions that can be used to create audit tables and database triggers for tracking `INSERT`, `UPDATE` and `DELETE` database actions.

`audit_tables` works purely at the database level and you will need to use raw sql to view audit logs.

It generates audit tables using the naming convention `audit_TABLE_NAME`, i.e. `audit_widgets`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'audit_tables'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install audit_tables

Optionally add an initializer file: `config/initializers/audit_tables.rb`, if you want to skip audits for some tables.

```ruby
AuditTables.configure do |config|
  config.exclude_tables << 'sessions'
end
```

NOTE: `ar_internal_metadata` and `schema_migrations` are skipped by default, but you can audit those as well by overriding the configuation option:

```ruby
AuditTables.configure do |config|
  config.exclude_tables = []
end
```

## Usage

The following public methods are exposed by the `AuditTables` module:

* `create_audit_tables_for_existing_tables`
  * Creates an audit table for all existing tables. You would only call this once from a migration:
  * `AuditTables.create_audit_tables_for_existing_tables`
* `create_audit_table_for(table_name)`
  * Create an audit table for a new table. See examples below.
* `change_audit_table_for(table_name)`
  * When you make changes in your tables, you can use this method to apply the same changes to the audit tables.
  * Optionally, you can modify the audit table structure using rails helper methods directly. This method is here for convience only.
* `build_audit_triggers_for(table_name)`
  * create the triggers on the new table or drop and re-create the audit triggers to handle all the new columns on the table passed as a parameter
  * Since the trigger uses `*` and expects your source table column order to match the audit table column order, you don't actually need to call this after making table changes, however it does not hurt.
* `check_for_audit_tables`
  * You can use this method in your specs, see spec example below.

#### Example Migration

```
class ExampleMigration < ActiveRecord::Migration[5.0]
  def change
    create_table :widgets do |t|
      t.string :name

      t.timestamps
    end

    AuditTables.create_audit_table_for(:widgets)
    AuditTables.build_audit_triggers_for(:widgets)

    add_column :widgets, :serial_number, :string
    AuditTables.change_audit_table_for(:widgets)
  end
end
```

#### Spec Example

This checks the database for audit tables and errors if a developer forgot to add one to a migration:

```
describe AuditTables do
  it 'ensure audit tables' do
    checks = AuditTables.check_for_audit_tables
    message = "You forgot to add audit tables for these tables: #{checks}"

    expect(checks).to be_empty, message
  end
end
```

## Notes

The structure of the audit tables:

* `audit_id`, integer auto incrementing
* `audit_operation` string - `INSERT`, `UPDATE` or `DELETE`
* `audit_timestamp` datetime (when the audit record was created)
* `*` all of the columns from the source table (column order must match)

The `DELETE` trigger copies all the values from the deleted record into the audit table, but it will probably look exactly like the previous `INSERT` or `UPDATE` audit record except for the `audit_timestamp`. If you are tracking which user updated a record, the delete audit probably won't reflect the correct user unless you did an update before the delete. We recommend doing soft deletes in most cases.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/syncordiahealth/audit_tables.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Change Log

* Version 1.0.0 (2017-01-20)
  * Initial Release
