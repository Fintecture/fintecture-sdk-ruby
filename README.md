# Fintecture

Fintecture is connected with most European banks and enables a user to initiate a payment directly from their bank account. This results to a bank transfer sent from the user's bank account directly to your bank account, skipping all intermediaries. Within the SEPA region, transfers take between 10 seconds to 1 business day to arrive on your bank account. No hidden fees. Check out [our website](https://fintecture.com/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fintecture'
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
Fintecture.private_key = %q(your_private_key)
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
Fintecture::Pis.get_access_token
```

### Connect 

#### Get connect URL
```ruby
payment_attrs = {
    amount: 123, 
    currency: 'EUR', 
    communication: 'Thanks Mom!', 
    execution_date: '2021-09-23', 
    beneficiary: {     
        name: "Bob Smith", 
        iban: "FR1420041010050500013M02606", 
        swift_bic: "BANKFRXXXXX", 
        street: "road of somewhere", 
        number: "2", 
        complement:"", 
        city: "Paris", 
        zip: "93160", 
        country: "FR",
        form: "",
        incorporation: "" 
    },
    debited_account_id: 'FR1420041010050500013M02606', 
    debited_account_type: 'iban',
    end_to_end_id: '5f78e902907e4209aa8df63659b05d24',
    scheme: 'AUTO', 
    customer_full_name: 'John Doe', 
    customer_email: 'john.doe@email.com',
    customer_phone: '666777888',
    customer_phone_prefix: '',
    customer_ip: '127.0.0.1', 
    customer_form: '',
    customer_incorporation: '', 
    customer_address: { 
        street: 'Main St.', 
        number: '123', 
        complement: '2nd floor', 
        city: 'Paris', 
        zip: '75000', 
        country: 'fr' 
    },
    redirect_uri: 'http://www.google.fr', 
    origin_uri: 'http://example.com/checkout?session=123',
    state: 'somestate' 
}
tokens = Fintecture::Pis.get_access_token

connect_response = Fintecture::Pis.get_connect tokens['access_token'], payment_attrs
connect_response_body = JSON.parse connect_response.body
url = connect_response_body['meta']['url']
```
Explanation of each field:

* amount: **[mandatory]** The amount of the payment initiation request. Min 1.00 and Max is variable based on bank's policy.
* currency: **[mandatory]** The currency of the payment initiation request. Currently, only EUR and GBP is supported.
* communication: **[optional]** A message sent to the beneficiary of the payment and visible on his bank statement. In the context of ecommerce payment collection, the order reference is inputted here (with an optional prefer ex: REF#23444)
* execution_date: **[optional]** A future date to execute the payment. If the execution_date field is omitted, the payment is to be sent immediately.
* beneficiary: **[optional]** The beneficiary of the payment. It has the following structure:
  * name: **[optional]** The beneficiary name
  * iban: **[optional]** The beneficiary iban
  * swift_bic: **[optional]** The beneficiary swift or bic code
  * street: **[optional]** The beneficiary address street name
  * number: **[optional]** The beneficiary address number
  * complement: **[optional]** Complement information to the beneficiary address
  * city: **[optional]** The beneficiary address city
  * zip: **[optional]** The beneficiary address zip code
  * country: **[optional]** The beneficiary country code (2 letters)
  * form: **[optional]** 
  * incorporation: **[optional]** 
* debited_account_id: **[optional]** Predefine the account which which the payment will be done
* debited_account_type: **[mandatory if debited_account_id]** "internal" or "iban", "bban".
* end_to_end_id: **[optional]** A unique ID given by the creator of the payment and send to the bank. By default de session_id is used.
* scheme: **[optional]** The payment scheme to use. Default: AUTO (automatic selection), SEPA, INSTANT_SEPA	
* customer_full_name: **[mandatory]** The full name of the payer
* customer_email: **[mandatory]** The email of the payer
* customer_phone: **[optional]** The phone of the payer
* customer_phone_prefix: **[optional]**
* customer_ip: **[mandatory]** The ip address of the payer
* customer_address: **[optional]** The address of the payer. It has the following structure:
  * street: **[optional]** The address street name
  * number: **[optional]** The address number
  * complement: **[optional]** Complement information to the address
  * city: **[optional]** The address city* 
  * zip: **[optional]** The address zip code
  * country: **[optional]** The country code (2 letters)
* redirect_uri: **[mandatory]** The callback URL to which the customer is redirected after authentication with his bank
* origin_uri: **[optional]** A URL to which the customer will be redirected if he wants to exit Fintecture Connect
* state: **[optional]** A state parameter which is sent back on callback

#### Get Request-to-pay

```ruby
payment_attrs = {
    x_language: 'fr',
    amount: 123, 
    currency: 'EUR', 
    communication: 'Thanks Mom!', 
    customer_full_name: 'John Doe', 
    customer_email: 'john.doe@email.com',
    customer_phone: '666777888',
    customer_phone_prefix: '+33',
    customer_address: { 
        street: 'Main St.', 
        number: '123', 
        city: 'Paris', 
        zip: '75000', 
        country: 'fr' 
    },
    expirary: 86400, 
    cc: 'exemple@gmail.com',
    bcc: 'exemple@gmail.com',
    redirect_uri: 'http://www.google.fr'
}
tokens = Fintecture::Pis.get_access_token

request_to_pay_response = Fintecture::Pis.request_to_pay @tokens['access_token'], payment_attrs
request_to_pay_response_body = JSON.parse request_to_pay_response.body
meta = request_to_pay_response_body['meta']
```
Explanation of each field:

* x_language: **[mandatory]** 
* amount: **[mandatory]** The amount of the payment initiation request. Min 1.00 and Max is variable based on bank's policy.
* currency: **[mandatory]** The currency of the payment initiation request. Currently, only EUR and GBP is supported.
* communication: **[optional]** A message sent to the beneficiary of the payment and visible on his bank statement. In the context of ecommerce payment collection, the order reference is inputted here (with an optional prefer ex: REF#23444)
* customer_full_name: **[mandatory]** The full name of the payer
* customer_email: **[mandatory]** The email of the payer
* customer_phone: **[mandatory]** The phone of the payer
* customer_phone_prefix: **[mandatory]**
* customer_address: **[optional]** The address of the payer. It has the following structure:
  * street: **[optional]** The address street name
  * number: **[optional]** The address number
  * city: **[optional]** The address city* 
  * zip: **[optional]** The address zip code
  * country: **[optional]** The country code (2 letters)
* expirary: **[optional]** The number of seconds of the validity of the request to pay, by default 86400	
* cc: **[optional]** The CC email to receive a copy (If multiple emails, the emails must be concatenated with a comma.)	
* bcc: **[optional]** The BCC email to receive a copy (If multiple emails, the emails must be concatenated with a comma.)	
* redirect_uri: **[optional]** The callback URL to which the customer is redirected after authentication with his bank




#### Get a specific payment

```ruby
payment_response = Fintecture::Pis.get_payments @tokens['access_token'], @session_id
payment_response_body = JSON.parse payment_response.body

verified = (payment_response_body['meta']['status'] === 'payment_created')
```

If the payment was success, the status of the response (_payment_response_body['meta']['status']_) should be **payment_created**

#### Get payments

```ruby
payments_response = Fintecture::Pis.get_payments @tokens['access_token']
payments_response_body = JSON.parse payments_response.body
payments_array = payment_response_body["data"]
```

If the payment was success, the status of the response (_payment_response_body['meta']['status']_) should be **payment_created**


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Fintecture/fintecture-sdk-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [GPL-3.0 License](http://www.gnu.org/licenses/gpl-3.0.txt).

## Code of Conduct

Everyone interacting in the Fintecture project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Fintecture/fintecture-sdk-ruby/blob/master/CODE_OF_CONDUCT.md).
