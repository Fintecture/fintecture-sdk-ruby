# frozen_string_literal: true

require 'json'

config = JSON.parse(File.read('./spec/api/ais/config.json'))
customer_id = config['customer_id']
code = config['code']

RSpec.describe Fintecture::Authentication do
  ais_client = Fintecture::AisClient.new({
                                           environment: config['environment'],
                                           app_id: config['app_id'],
                                           app_secret: config['app_secret'],
                                           private_key: config['private_key']
                                         })

  # ------------ TESTS ------------
  it 'POST /refreshtoken' do
    ais_client.generate_token code
    new_token = ais_client.generate_refresh_token

    token_type = new_token['token_type']
    access_token = new_token['access_token']

    expect(access_token).not_to be_empty
    expect(token_type).not_to be_empty
    expect(token_type).to eq 'Bearer'
  end

  it 'POST /refreshtoken + optional refreshToken' do
    access_token_response = ais_client.generate_token code
    refresh_token = access_token_response['refresh_token']

    new_token = ais_client.generate_refresh_token refresh_token

    token_type = new_token['token_type']
    access_token = new_token['access_token']

    expect(access_token).not_to be_empty
    expect(token_type).not_to be_empty
    expect(token_type).to eq 'Bearer'
  end
end
