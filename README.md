# JSON::Schema::Lite [![Build Status](https://travis-ci.org/munky69rock/json-schema-lite.svg?branch=master)](https://travis-ci.org/munky69rock/json-schema-lite)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json-schema-lite'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json-schema-lite

## Usage

- generate by block
```ruby
JSON::Schema::Lite.generate do
  string :title, required: true
  string :body, required: true
  number :vote
  object :author do
    string :name
  end
  array :tags, :string
  array :related do
    string :title
  end
end
```

- generate by object
```ruby
JSON::Schema::Lite.generate type: :object,
  required: [:title, :body],
  properties: {
    title: :string,
    body: :string,
    vote: :number,
    author: {
      type: :object,
      properties: {
        name: :string,
      }
    },
    tags: [:string],
    related: [
      type: :object,
      properties: {
         title: :string
      }
    ]
  }
```

- generated json schema
```json
{
  "type": "object",
  "required": ["title", "body"],
  "properties": {
    "title": { "type": "string" },
    "body": { "type": "string" },
    "vote": { "type": "number" },
    "author": {
      "type": "object",
      "properties": {
        "name": { "type": "string" }
      }
    },
    "tags": {
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "related": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "title": { "type": "string" }
        }
      }
    }
  }
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/munky69rock/json-schema-lite. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
