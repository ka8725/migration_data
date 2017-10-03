# MigrationData

[![Build Status](https://travis-ci.org/ka8725/migration_data.svg?branch=master)](https://travis-ci.org/ka8725/migration_data)

This gem provides functionality to write any code in migrations safely without regression.

Sometimes we have to write some Rails code in the migrations and it's hard to
keep them in a working state because models which are used there change too often. There are
some techniques which help to avoid these pitfalls. For example, define model
classes in the migrations or write raw SQL. But they don't help in 100% of all cases.
This gem promises to solve this problem in a simple way.

Currently the gem supports Rails 4 and Rails 5.

If you still don't understand what this gem is for please check out [this blog post](http://railsguides.net/2014/01/30/change-data-in-migrations-like-a-boss/).

## Installation

Add this line to your application's Gemfile:

    gem 'migration_data'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install migration_data

## Usage

In your migration define a `data` method:

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

That's it. Now when you run migrations with the `rake db:migrate` command the `data` method will be run on `up`.
When you rollback migrations with the `rake db:rollback` command the `rollback` method will be run on `down`.

> Note: in some circumstances, the `reset_column_information` method should be called on a model which table is changed in the migration. Especially when you are certain that there should be present some column for a model but it's absent for some reason. Read more about this in the [official Rails docs](http://guides.rubyonrails.org/v4.1/migrations.html#using-models-in-your-migrations).

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

The helper to load migrations `require_migration` is defined in the `migration_data/testing`. So you should to require it to have access to this convinient require extension.

## Clean old migration

Use `rake db:migrate:squash` to remove all your old migrations and generate one migration with the current database schema. You don't have to run migrations after this because the generated migration will have the latest database version.

## Contributing

1. Fork it ( http://github.com/ka8725/migration_data/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
