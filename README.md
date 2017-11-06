[![Build Status](https://travis-ci.org/serihiro/rasteira.svg?branch=master)](https://travis-ci.org/serihiro/rasteira)
[![Gem Version](https://badge.fury.io/rb/rasteira.svg)](https://badge.fury.io/rb/rasteira)

# Rasteira

- Rasteira is 
    - a simple on memory thread base job queue worker.
    - embeddable to a ruby product.
- Rasteira is **not**
    - a dependent daemon process unlike [Sidekiq](https://github.com/mperham/sidekiq), [Resque](https://github.com/resque/resque) and [Delayed::Job](https://github.com/collectiveidea/delayed_job) etc.
    - working as a distributed system: just a single server.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rasteira'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rasteira

## Usage

Firstly you need to implement a worker like the following.

```ruby:example/hellow_worker.rb
class HelloWorker
  def perform(name)
    puts "Hello, #{name}"
  end
end
```

And start Embed Worker Manager and enqueue a job.

```ruby
manager = Rasteira::EmbedWorker::Manager.run
manager.enqueue_job!('HelloWorker', 'example/hello_worker.rb', 'serihiro')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/serihiro/rasteira. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rasteira project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rasteira/blob/master/CODE_OF_CONDUCT.md).
