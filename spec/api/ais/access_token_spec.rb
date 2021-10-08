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
  it 'POST /accesstoken' do
    access_token_response = ais_client.generate_token code
    access_token = access_token_response['access_token']
    refresh_token = access_token_response['refresh_token']
    token_type = access_token_response['token_type']
    expires_in = access_token_response['expires_in']

    expect(access_token).not_to be_empty
    expect(refresh_token).not_to be_empty
    expect(token_type).not_to be_empty
    expect(token_type).to eq 'Bearer'
    expect(!expires_in.nil?).to be_truthy
  end
end
