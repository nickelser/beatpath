# Beatpath [![Build Status](https://travis-ci.org/nickelser/beatpath.svg?branch=master)](https://travis-ci.org/nickelser/beatpath) [![Gem Version](https://badge.fury.io/rb/beatpath.svg)](http://badge.fury.io/rb/beatpath)

Ruby implementation of the Schulze voting method (https://en.wikipedia.org/wiki/Schulze_method).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "beatpath"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install beatpath

## Usage

```ruby
# expected input is an array of arrays
ballots = [
  [55, 34, 56, 76], # each array is a ballot with candidate IDs, in ranked order
                    # so, this ballot implies that they preferred candidate ID 55 first, then
                    # candidate ID 34 second
                    # the candidate ID can be any unique object (symbol, AR record, etc.)
  [55, 56, 76, 34],
  [76, 55, 56, 34],
  [55, 56, 76, 34]
]

winners = Beatpath::Vote.new(ballots).winners
# [55, 56, 76, 34] means that candidate ID 55 is in first place, 56 is in second place, 76 in third, and 34 is last
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nickelser/beatpath.

