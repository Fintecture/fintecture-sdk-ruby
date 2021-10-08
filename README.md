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

By default `sandbox` is the initial environment, but you can change to sandbox by doing

Initialize your PIS client 

```ruby
pis_client = Fintecture::PisClient.new({
    environment: 'sandbox', # => ["sandbox", "test", "production"]
    app_id: 'your_app_id',
    app_secret: 'your_app_secret',
    private_key: %q(your_private_key)
})
```    



Initialize your AIS client 

```ruby
ais_client = Fintecture::AisClient.new({
    environment: 'sandbox', # => ["sandbox", "test", "production"]
    app_id: 'your_app_id',
    app_secret: 'your_app_secret',
    private_key: %q(your_private_key)
})
```



## PIS     
PIS client properties
```ruby
pis_client.app_id
pis_client.app_secret
pis_client.private_key
pis_client.environment
pis_client.token
pis_client.token_expires_in
```

#### Access token
This method return the token and store it in the client for future requests
```ruby
pis_client.generate_token
```


#### POST /connect
Documentation => https://docs.fintecture.com/v2/#post-post-post-connect
 - An example of the JSON payload in the right column in "Request Body" section
 - An exemple of response in the right column in "Request Body" section
 - The definitions of each field in the "Body Parameters" section

```ruby
# connect (payload, state, redirect_uri = nil, origin_uri = nil)
#       payload: {}
#       state: string
#       redirect_uri: string
#       origin_uri: string

response = pis_client.connect payload, "my-state", "https://www.my-redirect-uri.fr", "https://www.my-origine-uri.fr"
```


#### POST /initiate
Documentation => https://docs.fintecture.com/v2/#post-post-post-initiate
 - An example of the JSON payload in the right column in "Request Body" section
 - An exemple of response in the right column in "Request Body" section
 - The definitions of each field in the "Body Parameters" section

```ruby
# initiate (payload, provider_id, redirect_uri, state = nil)
#       payload: {}
#       provider_id: string
#       redirect_uri: string
#       state: string

response = pis_client.initiate payload, "cmcifrpp", "https://www.my-redirect-uri.fr", "my-state"
```

#### GET /payments
Documentation => https://docs.fintecture.com/v2/#get-get-get-payments
 - An exemple of response in the right column in "Request Body" section

```ruby
# payments (session_id = nil)
#       session_id: string

response = pis_client.payments "7f47d3675f5d4964bc416b43af63b06e"
OR
response = pis_client.payments 
```
This endpoint returns the details of all transfers or of a specific transfer

#### POST /refund
Documentation => https://docs.fintecture.com/v2/#post-post-post-refund
 - An exemple of response in the right column in "Request Body" section

```ruby
# refund (session_id, amount = nil)
#       session_id: string
#       amount: number

response = pis_client.refund "7f47d3675f5d4964bc416b43af63b06e", 5.75
```
If the amount is not specified, refund the total

#### POST /request-to-pay
Documentation => https://docs.fintecture.com/v2/#post-post-post-request-to-pay
 - An example of the JSON payload in the right column in "Request Body" section
 - An exemple of response in the right column in "Request Body" section
 - The definitions of each field in the "Body Parameters" section
 - The definition of x_language field in the "Header Parameters" section

```ruby
# refund (payload, x_language, redirect_uri = nil)
#       payload: {}
#       x_language: string
#       redirect_uri: string

response = pis_client.request_to_pay payload, 'fr', "https://www.my-redirect-uri.fr"
```

#### GET /settlements
Documentation => https://docs.fintecture.com/v2/#get-get-get-settlements
 - An exemple of response in the right column in "Request Body" section

```ruby
# settlements (settlement_id = nil)
#       settlement_id: string

response = pis_client.settlements
OR
response = pis_client.settlements "127335fdeb073e0eb2313ba0bd71ad44"
```

## AIS     
AIS client properties
```ruby
ais_client.app_id
ais_client.app_secret
ais_client.private_key
ais_client.environment
ais_client.token
ais_client.refresh_token
ais_client.token_expires_in
``` 
#### GET /connect
Documentation => https://docs.fintecture.com/v2/#get-get-get-connect
 - An exemple of response in the right column in "Request Body" section

```ruby
# connect (state, redirect_uri, scope = nil)
#       state: string
#       redirect_uri: string
#       scope: string

response = ais_client.connect "my-state", "https://www.my-redirect-uri.fr"
```
When you follow the returned url, you'll be redirect with "customer_id" & "code" parameters
```ruby
customer_id = "fa51058b5f8306f1e048f1adda5488a9"
code = "f66ec660b0bbd2797bf6847fb4b98454"
```

#### Access token
Documentation => https://docs.fintecture.com/v2/#post-post-post-oauth-accesstoken

This method return the token and store it in the client for future requests
```ruby
ais_client.generate_token code
```

#### Refresh token
Documentation => https://docs.fintecture.com/v2/#post-post-post-oauth-refreshtoken

This method return the token and store it in the client for future requests
If you do not pass the refreshtoken as a parameter, the client refreshtoken will be used
```ruby
# generate_refresh_token (refresh_token = nil)
#       refresh_token: string

ais_client.generate_refresh_token
```

#### GET /authorize
Documentation => https://docs.fintecture.com/v2/#get-get-get-authorize
 - An exemple of response in the right column in "Request Body" section
 - The definition of "x_psu_id" and "x_psu_ip_address" fields in the "Header Parameters" section

```ruby
# authorize (app_id_auth: false, provider_id:, redirect_uri:, state: nil, x_psu_id: nil, x_psu_ip_address: nil)
#       app_id_auth: boolean
#       provider_id: string
#       redirect_uri: string
#       state: string
#       x_psu_id: string
#       x_psu_ip_address: string

response = ais_client.authorize app_id_auth: false, provider_id: "agfbfr", redirect_uri: "https://www.google.fr", state: "ok", x_psu_id: "123456", x_psu_ip_address: "192.168.1.1"
```

#### GET /authorize/decoupled
Documentation => https://docs.fintecture.com/v2/#get-get-get-authorize-decoupled
 - An exemple of response in the right column in "Request Body" section

```ruby
# authorize_decoupled (app_id_auth: false, provider_id:, polling_id:)
#       app_id_auth: boolean
#       provider_id: string
#       polling_id: string

response = ais_client.authorize_decoupled app_id_auth: false, provider_id: "agfbfr", polling_id: "1234"
```

#### GET /accounts
Documentation => https://docs.fintecture.com/v2/#get-get-get-accounts
 - An exemple of response in the right column in "Request Body" section

```ruby
# accounts (customer_id:, account_id: nil, remove_nulls: nil, withBalances: nil)
#       customer_id: string
#       account_id: string
#       remove_nulls: boolean
#       withBalances: boolean

response = ais_client.accounts customer_id: customer_id, account_id: nil, remove_nulls: nil, withBalances: nil
```

#### GET /transactions
Documentation => https://docs.fintecture.com/v2/#get-get-get-transactions
 - An exemple of response in the right column in "Request Body" section

```ruby
# transactions (customer_id:, account_id:, remove_nulls: nil, convert_dates: nil, filters: nil)
#       customer_id: string
#       account_id: string
#       remove_nulls: boolean
#       convert_dates: boolean
#       filters: {}

transactions_filters = {
  "filter[date_to]": "2020-01-01",
  'filter[date_from]': "max" # Date or 'max'
}
response = ais_client.transactions customer_id: customer_id, account_id: "b71722204d1a3f5ecd895", remove_nulls: true, convert_dates: true, filters: transactions_filters
```

#### GET /accountholders
Documentation => https://docs.fintecture.com/v2/#get-get-get-accountholders
 - An exemple of response in the right column in "Request Body" section

```ruby
# account_holders (customer_id:, remove_nulls: nil)
#       customer_id: string
#       remove_nulls: boolean

response = ais_client.account_holders customer_id: customer_id, remove_nulls: true
```

#### DELETE /customer
Documentation => https://docs.fintecture.com/v2/#delete-delete-delete-customer
 - An exemple of response in the right column in "Request Body" section

```ruby
# account_holders (customer_id:)
#       customer_id: string

response = ais_client.delete_customer customer_id: customer_id
```
## RESSOURCES
Use the PIS client to get ressources. The "generate_token" step is not needed for this calls

#### GET /providers
Documentation => https://docs.fintecture.com/v2/#get-get-get-providers
 - An exemple of response in the right column in "Request Body" section

```ruby
# providers (provider_id: nil, paramsProviders: nil)
#       provider_id: string
#       paramsProviders: string

paramsProviders = {
    'filter[country]': 'FR',
    'filter[pis]': 'SEPA',
    'filter[ais]': 'Accounts',
    'filter[psu_type]': 'retail',
    'filter[auth_model]': 'redirect',
    'sort[name]': 'DESC',
    'sort[full_name]': 'DESC',
    'sort[country]': 'DESC',
    'sort[provider_id]': 'DESC'
}
response = pis_client.providers provider_id: 'agfbfr', paramsProviders: paramsProviders
```

#### GET /applications
Documentation => https://docs.fintecture.com/v2/#get-get-get-applications
 - An exemple of response in the right column in "Request Body" section

```ruby
# applications ()

response = pis_client.applications
```

#### GET /testaccounts
Documentation => https://docs.fintecture.com/v2/#get-get-get-testaccounts
 - An exemple of response in the right column in "Request Body" section

```ruby
# test_accounts (provider_id = nil)
#       provider_id: string

response = pis_client.test_accounts 'agfbfr'
```

## API Errors handling
Hash version
```ruby
begin
    pis_client.refund "7f47d3675f5d4964bc416b43af63b06e", 1
rescue => e
    error = JSON.parse e.to_s
    puts error
end
```

```ruby
{
    "type"=>"Fintecture api",
    "status"=>401,
    "errors"=>[
        {
            "code"=>"invalid_token",
            "title"=>"Invalid Token",
            "message"=>"The token is either invalid or expired."
        }
    ],
    "error_string"=>"\nFintecture server errors : \n status: 401 \n code: unauthorized\n id : 3006ddbf-2f97-44d8-9f63-35711b78e8a6\n\n   code: invalid_token\n   title: Invalid Token\n   message: The token is either invalid or expired.\n\n"
}
```
Text version
```ruby
begin
    pis_client.refund "7f47d3675f5d4964bc416b43af63b06e", 1
rescue => e
    error = JSON.parse e.to_s
    puts error['error_string']
end
```

```ruby
Fintecture server errors :
 status: 401
 code: unauthorized
 id : 2adb9e35-ff0d-4477-959e-b1b1a7d7c812

   code: invalid_token
   title: Invalid Token
   message: The token is either invalid or expired.

```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Fintecture/fintecture-sdk-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [GPL-3.0 License](http://www.gnu.org/licenses/gpl-3.0.txt).

## Code of Conduct

Everyone interacting in the Fintecture project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Fintecture/fintecture-sdk-ruby/blob/master/CODE_OF_CONDUCT.md).
