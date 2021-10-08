# frozen_string_literal: true

require 'json'
require 'fintecture/api/ais/transactions'

config = JSON.parse(File.read('./spec/api/ais/config.json'))
customer_id = config['customer_id']
code = config['code']

account_id = ''

RSpec.describe Fintecture::Ais::Transactions do
  ais_client = Fintecture::AisClient.new({
                                           environment: config['environment'],
                                           app_id: config['app_id'],
                                           app_secret: config['app_secret'],
                                           private_key: config['private_key']
                                         })

  transactions_filters = {
    "filter[date_to]": '2021-01-01',
    "filter[date_from]": 'max'
  }

  # ------------ TESTS ------------
  it 'GET /transactions' do
    ais_client.generate_token code

    accounts_response = ais_client.accounts customer_id: customer_id, account_id: nil, remove_nulls: false,
                                            withBalances: false
    account = accounts_response['data'].first
    account_id = account['id']

    transactions_response = ais_client.transactions customer_id: customer_id, account_id: account_id,
                                                    remove_nulls: false, convert_dates: false, filters: nil
    transaction = transactions_response['data'].first

    expect(transaction['id']).not_to be_empty
    expect(transaction['type']).to eq('transactions')
    expect(transaction['attributes']['amount']).not_to be_empty
    expect(transaction['attributes']['currency']).not_to be_empty
    expect(transaction['attributes']['communication']).not_to be_empty
    expect(transaction['attributes']['status']).not_to be_empty
  end

  it 'GET /transactions + optional remove_nulls & convert_dates' do
    ais_client.generate_token code

    transactions_response = ais_client.transactions customer_id: customer_id, account_id: account_id,
                                                    remove_nulls: true, convert_dates: true, filters: nil
    transaction = transactions_response['data'].first

    # TODO: Analyse converted date format
    expect(transaction['id']).not_to be_empty
    expect(transaction['type']).to eq('transactions')
    expect(transaction['attributes']['amount']).not_to be_empty
    expect(transaction['attributes']['currency']).not_to be_empty
    expect(transaction['attributes']['communication']).not_to be_empty
    expect(transaction['attributes']['status']).not_to be_empty
  end

  it 'GET /transactions + optional filters' do
    ais_client.generate_token code

    transactions_response = ais_client.transactions customer_id: customer_id, account_id: account_id,
                                                    remove_nulls: false, convert_dates: false, filters: transactions_filters
    transaction = transactions_response['data'].first

    # TODO: Analyse converted date format
    expect(transaction['id']).not_to be_empty
    expect(transaction['type']).to eq('transactions')
    expect(transaction['attributes']['amount']).not_to be_empty
    expect(transaction['attributes']['currency']).not_to be_empty
    expect(transaction['attributes']['communication']).not_to be_empty
    expect(transaction['attributes']['status']).not_to be_empty
  end
end
