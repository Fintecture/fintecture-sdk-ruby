# frozen_string_literal: true

require 'json'
require 'fintecture/api/ais/accounts'

config = JSON.parse(File.read('./spec/api/ais/config.json'))
customer_id = config['customer_id']
code = config['code']

account_id = ''

RSpec.describe Fintecture::Ais::Accounts do
  ais_client = Fintecture::AisClient.new({
                                           environment: config['environment'],
                                           app_id: config['app_id'],
                                           app_secret: config['app_secret'],
                                           private_key: config['private_key']
                                         })

  # ------------ TESTS ------------
  it 'GET /accounts' do
    ais_client.generate_token code

    accounts_response = ais_client.accounts customer_id: customer_id, account_id: nil, remove_nulls: false,
                                            withBalances: false
    account = accounts_response['data'].first
    account_id = account['id']

    expect(account['type']).to eq('accounts')
    expect(account['attributes']['iban']).not_to be_empty
    expect(account['attributes']['account_id']).not_to be_empty
    expect(account['attributes']['account_name']).not_to be_empty
    expect(account['attributes']['account_type']).not_to be_empty
  end

  it 'GET /accounts + optional remove_nulls' do
    ais_client.generate_token code

    accounts_response = ais_client.accounts customer_id: customer_id, account_id: nil, remove_nulls: true,
                                            withBalances: nil
    account = accounts_response['data'].first

    expect(account['type']).to eq('accounts')
    expect(account['attributes']['iban']).not_to be_empty
    expect(account['attributes']['account_id']).not_to be_empty
    expect(account['attributes']['account_name']).not_to be_empty
    expect(account['attributes']['account_type']).not_to be_empty
  end

  it 'GET /accounts + optional remove_nulls & withBalances' do
    ais_client.generate_token code

    accounts_response = ais_client.accounts customer_id: customer_id, account_id: nil, remove_nulls: true,
                                            withBalances: true
    account = accounts_response['data'].first

    expect(account['type']).to eq('accounts')
    expect(account['attributes']['iban']).not_to be_empty
    expect(account['attributes']['account_id']).not_to be_empty
    expect(account['attributes']['account_name']).not_to be_empty
    expect(account['attributes']['account_type']).not_to be_empty
    expect(!account['attributes']['balance_available'].nil?).to be_truthy
  end

  it 'GET /accounts/[account_id]' do
    ais_client.generate_token code
    accounts_response = ais_client.accounts customer_id: customer_id, account_id: account_id, remove_nulls: nil,
                                            withBalances: nil
    account = accounts_response['data']

    expect(accounts_response['meta']['customer_id']).to eq(customer_id)
    expect(account['type']).to eq('accounts')
    expect(account['attributes']['iban']).not_to be_empty
    expect(account['attributes']['account_id']).not_to be_empty
    expect(account['attributes']['currency']).not_to be_empty
    expect(!account['attributes']['balance_available'].nil?).to be_truthy
  end
end
