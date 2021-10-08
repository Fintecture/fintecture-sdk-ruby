# frozen_string_literal: true

require './lib/fintecture'

config = JSON.parse(File.read('./exemples/config_ais.json'))

ais_client = Fintecture::AisClient.new({
                                         environment: config['environment'],
                                         app_id: config['app_id'],
                                         app_secret: config['app_secret'],
                                         private_key: config['private_key']
                                       })

# ######################## AIS ########################

# ------------ Connect ------------
connect_response = ais_client.connect 'ok', 'https://www.google.fr'
connect_id = connect_response['meta']['connect_id']
url = connect_response['meta']['url']

puts "Connect url => #{url}"

# Put the return of connect url here
customer_id = 'c84e6a2c66862f6ce169a11262b28f4c'
code = '173535d0acc16271e7942cc6e1772a5b'

# ------------ Get access token ------------
ais_client.generate_token code
ais_client.generate_refresh_token
# ------------ Authorize ------------
puts ais_client.authorize app_id_auth: true, provider_id: 'agfbfr', redirect_uri: 'https://www.google.fr', state: 'ok',
                          x_psu_id: nil, x_psu_ip_address: nil
# ------------ Authorize decoupled ------------
puts ais_client.authorize_decoupled app_id_auth: false, provider_id: 'agfbfr', polling_id: '1234'
# ------------ Get accounts ------------
accounts_response = ais_client.accounts customer_id: customer_id, account_id: nil, remove_nulls: nil, withBalances: nil
account = accounts_response['data'].first
account_id = account['id']
# ------------ Get transactions ------------
transactions_filters = {
  "filter[date_to]": '2020-01-01',
  'filter[date_from]': 'max'
}
transactions_response = ais_client.transactions customer_id: customer_id, account_id: account_id, remove_nulls: true,
                                                convert_dates: true, filters: transactions_filters
transaction = transactions_response['data'].first
puts transaction
# ------------ Get account holders ------------
# Caution the hasAccountholders field in db must have a value = 1.
puts ais_client.account_holders customer_id: customer_id, remove_nulls: nil
# ------------ Delete customer ------------
# Customer not found if customer you don't use the api before
puts ais_client.delete_customer customer_id: customer_id
