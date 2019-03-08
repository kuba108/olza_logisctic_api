# OlzaApi

Connect your APP to spedition Olza system over API. 

Olza Logistic API client is a useful gem for developers who want to integrate basic API actions into their application. 
It covers most of the needed possibilities.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'olza_api', git: 'https://github.com/kuba108/olza_logistic_api.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install olza_api

## Usage

Central point in this gem is model Client which can create requests and handles its responses.
Basic usage is to call methods in this order: 

* create_shipments - creates shipments in Olza panel (admin)
* post_shipments - creates shipments on transporter system (GLS, PPL, etc.)
* get_labels - returns PDF label in required format and encoded as Base64
* get_statuses - returns information about shipments

More info will be written soon.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/olza_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the OlzaApi project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/olza_api/blob/master/CODE_OF_CONDUCT.md).
