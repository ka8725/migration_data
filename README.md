# MigrationData

This gem provides functionality to write any code in migrations safely without regression.

Sometimes we have to write some Rails code in the migrations and it's hard to
keep them in working state because models wich are used there changes too often. there
some techniques which help to avoid these pitfalls. For example, define model
classes in the migrations or write raw SQL. But they don't help in 100% cases anyway.
This gem promises to solve the problem in a simple way.

Currently the gem supports Rails 4 and Ruby >= 2.0.

## Installation

Add this line to your application's Gemfile:

    gem 'migration_data'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install migration_data

## Usage

Just define in your migration `data` method:

```ruby
class CreateUsers < ActiveRecord::Migration
  def change
    # Database schema changes as usual
  end

  def data
    User.create!(name: 'Andrey', email: 'ka8725@gmail.com')
  end
end
```

That's it. Now when you run migrations with the `rake db:migrate` command the `data` method will be run on `up`.

NOTE: it's not run on `down`. If you have any reason to do it please fell free to make pull request.

## Testing migrations

To keep your migrations working don't forget to write tests for them.
Possible `RSpec` test for the migration looks like this:

```ruby

require 'spec_helper'
require 'migration_data/testing'
require_migration 'create_users'

desribe CreateUsers do
  describe '#data' do
    it 'works' do
      expect { CreateUsers.new.data }.to_not raise_exception
    end
  end
end
```

The helper to load migrations `require_migration` is defined in the `migration_data/testing`. So you should to require it
to have access to this convinient require extension.

## Contributing

1. Fork it ( http://github.com/ka8725/migration_data/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
