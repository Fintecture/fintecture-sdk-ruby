# Fintecture

Fintecture is connected with most European banks and enables a user to initiate a payment directly from their bank account. This results to a bank transfer sent from the user's bank account directly to your bank account, skipping all intermediaries. Within the SEPA region, transfers take between 10 seconds to 1 business day to arrive on your bank account. No hidden fees. Check out [our website](https://fintecture.com/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fintecture', '~> 0.1.0'
```

or install it through our github repository

```ruby
gem 'fintecture', github: 'Fintecture/fintecture-sdk-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fintecture

## Usage

Get started by subscribing to a free developer account. Join today to get access to our sandbox by registering on the [developer console](https://console.fintecture.com) by creating your first sets of API Keys. When creating an account, specify you are an ECOMMERCE. When you’re ready to deploy to production, just go through the Activation Form in your console. Once the Fintecture Team activates your account, you’ll be ready to start receiving real bank transfers directly on the bank account specified during activation.

Initialize your client credentials

```ruby
Fintecture.app_id = 'your_app_id'
Fintecture.app_secret = 'your_app_secret'
Fintecture.app_private_key = %q(your_app_private_key)
```
    
    
#### Environments

By default `sandbox` is the initial environment, but you can change to sandbox by doing

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
