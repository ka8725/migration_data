# MigrationData

[![Build Status](https://travis-ci.org/ka8725/migration_data.svg?branch=master)](https://travis-ci.org/ka8725/migration_data)

This gem provides functionality to write any code in migrations safely without regression.

Sometimes we have to write some Rails code in the migrations and it's hard to
keep them in a working state because models which are used there change too often. There are
some techniques which help to avoid these pitfalls. For example, define model
classes in the migrations or write raw SQL. But they don't help in 100% of all cases.
This gem promises to solve this problem in a simple way.

If you still don't understand what this gem is for please check out [this blog post](http://railsguides.net/2014/01/30/change-data-in-migrations-like-a-boss/).

## Installation

Add this line to your application's Gemfile:

    gem 'migration_data'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install migration_data

## Usage

In your migration define a `#data` method:

```ruby
class CreateUsers < ActiveRecord::Migration
  def change
    # Database schema changes as usual
  end

  def data
    User.create!(name: 'Andrey', email: 'ka8725@gmail.com')
  end

  def rollback
    User.find_by(name: 'Andrey', email: 'ka8725@gmail.com').destroy
  end
end
```

Now when migrations run with `rake db:migrate` command the `#data` method is executed right after the standard `#change` or `#up` method.

When migrations roll back with `rake db:rollback` command the `#rollback` is executed right after the standard `#change` or `#down` method.

It might appear that a data migration should run *before* the standard `#change`, `#up`, and `#down` methods. Define `#data_before` and `#rollback_before` methods for "up" and "down" directions correspondingly. There are also `#data_after` and `#rollback_after` methods for symmetry in that case, but basically they play the same role as `#data` and `#rollback` methods.

All these methods can be defined in one migration. They are executed in the following order when migration is run on up:
- `#data_before`
- `#change/up`
- `#data`
- `#data_after`

and on down:

- `#rollback_before`
- `#change/down`
- `#rollback`
- `#rollback_after`.

> Note: in some circumstances, the `reset_column_information` method should be called on a model which table is changed in the migration. Especially when you are certain that there should be present some column for a model but it's absent for some reason. Read more about this in the [official Rails docs](http://guides.rubyonrails.org/v4.1/migrations.html#using-models-in-your-migrations).

## Skipping data migrations execution

At some point, one might realize that data migrations should not run on particular environments, e.g. `test`.

On performing migrations in `test` environment, a data migration might try to add the same data that has already been added by seeds. In that case, migrations might fail with a duplication error.

Use `MigrationData.config.skip = true` to skip data migrations execution. One might put this code in an initializer, e.g. `config/initializers/migration_data.rb`:

```ruby
if Rails.env.test?
  MigrationData.config.skip = true
end
```

## Testing migrations

To keep your migrations working don't forget to write tests for them. It's preferably to put the tests for migrations into `spec/db/migrations` folder, but actually it's up to you. Possible `RSpec` test (`spec/db/migrations/create_user.rb`) for the migration looks like this:

```ruby
require 'spec_helper'
require 'migration_data/testing'
require_migration 'create_users'

describe CreateUsers do
  describe '#data' do
    it 'works' do
      expect { described_class.new.data }.to_not raise_exception
    end
  end

  describe '#rollback' do
    before do
      described_class.new.data
    end

    it 'works' do
      expect { described_class.new.rollback }.to_not raise_exception
    end
  end
end
```

The helper to load migrations `require_migration` is defined in the `migration_data/testing`. So you should to require it to have access to this convenient require extension.

## Contributing

1. Fork it ( http://github.com/ka8725/migration_data/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
