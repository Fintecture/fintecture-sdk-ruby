# frozen_string_literal: true

require 'json'
require 'fintecture/api/ais/account_holders'

config = JSON.parse(File.read('./spec/api/ais/config.json'))
customer_id = config['customer_id']
code = config['code']

RSpec.describe Fintecture::Ais::AccountHolders do
  ais_client = Fintecture::AisClient.new({
                                           environment: config['environment'],
                                           app_id: config['app_id'],
                                           app_secret: config['app_secret'],
                                           private_key: config['private_key']
                                         })

  # ------------ TESTS ------------
  it 'GET /account_holders' do
    ais_client.generate_token code

    account_holders_response = ais_client.account_holders customer_id: customer_id, remove_nulls: nil
    data = account_holders_response['data'].first
    meta = account_holders_response['meta']

    expect(data['id']).not_to be_empty
    expect(data['type']).to eq('accountholders')
    expect(data['attributes']['full_name']).not_to be_empty

    expect(meta['provider']).not_to be_empty
    expect(meta['last_authentication']).not_to be_empty
  end

  it 'GET /account_holders + optional remove_nulls' do
    ais_client.generate_token code

    account_holders_response = ais_client.account_holders customer_id: customer_id, remove_nulls: true
    data = account_holders_response['data'].first
    meta = account_holders_response['meta']

    expect(data['id']).not_to be_empty
    expect(data['type']).to eq('accountholders')
    expect(data['attributes']['full_name']).not_to be_empty

    expect(meta['provider']).not_to be_empty
    expect(meta['last_authentication']).not_to be_empty
  end
end
