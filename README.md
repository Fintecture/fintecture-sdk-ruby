# Fintecture

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/fintecture`. To experiment with that code, run `bin/console` for an interactive prompt.

Fintecture is connected with most European banks and enables a user to initiate a payment directly from their bank account. This results to a bank transfer sent from te user's bank account directly to your bank account, skipping all intermediaries. Within the SEPA region, transers take between 10 seconds to 1 business day to arrive on your bank account. No hidden fees. Check out [our website](https://fintecture.com/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fintecture', github: 'Fintecture/fintecture-sdk-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fintecture

## Usage

This is a very basic guide of how to use this gem. Click on the follow [link](https://docs.fintecture.com/) for specific information.

Initialize your client credentials

```ruby
Fintecture.app_id = 'your_app_id'
Fintecture.app_secret = 'your_app_secret'
Fintecture.app_private_key = %q(your_app_private_key)
```
    
    
#### Environments

By default `production` is the initial environment, but you can change to sandbox by doing

```ruby
Fintecture.environment = 'sandbox'
```

You can also see the available environments

    Fintecture::ENVIRONMENTS
     => ["sandbox", "production"]

### Authentication     
    

#### Access token

```ruby
Fintecture::Authentication.access_token
```

### Connect 

#### Get connect URL
```ruby
payment_attrs = {
    amount: 123,
    currency: 'EUR',
    order_id: 123,
    customer_id: 123,
    customer_full_name: 'John Doe',
    customer_email: 'john.doe@email.com',
    customer_ip: '127.0.0.1',
    end_to_end_id: '5f78e902907e4209aa8df63659b05d24', # uuid optional
    redirect_uri: '',
    origin_uri: ''
}
url = Fintecture::Connect.connect_url_pis payment_attrs
```
    
#### Verify URL parameters

```ruby
callback_params = {
    app_id: 'uri_app_id',
    app_secret: 'uri_app_secret',
    session_id: 'uri_session_id',
    status: 'uri_status',
    customer_id: 'uri_customer_id',
    provider: 'uri_provider',
    state: 'uri_state',
    s: 'uri_s'
}

Fintecture::Connect.verify_url_parameters callback_params
```
This function returns `true` if the parameters have verified, `false` in other case.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Fintecture/fintecture-sdk-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [GPL-3.0 License](http://www.gnu.org/licenses/gpl-3.0.txt).

## Code of Conduct

Everyone interacting in the Fintecture project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Fintecture/fintecture-sdk-ruby/blob/master/CODE_OF_CONDUCT.md).
