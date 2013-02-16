# The iCloud Reader

Want to use your iCloud accounts with a third-party app (like your android phone or Thunderbird Lightning)? Well, here's a simple tool to figure out what your URLs are. 

This is just a rewrite, in Ruby, of http://icloud.niftyside.com/. Props go there for the original.

## Installation

Add this line to your application's Gemfile:

    gem 'icloud-reader'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install icloud-reader

## Usage

The command is `icloud-reader`

Without any args:

Usage:
    [] [OPTIONS] SUBCOMMAND [ARGS] ...

Subcommands:
    calendars                     list the calendars and their URLs (as YAML)
    contacts                      get your CardDAV url

Options:
    -s, --server-number SERVER_NUMBER the number of the server to use
    -h, --help                    print help

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
