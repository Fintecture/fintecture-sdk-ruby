# frozen_string_literal: true

require 'json'

config = JSON.parse(File.read('./spec/api/pis/config.json'))

RSpec.describe Fintecture::Authentication do
  pis_client = Fintecture::PisClient.new({
    environment: config['environment'],
    app_id: config['app_id'],
    app_secret: config['app_secret'],
    private_key: config['private_key']
  })

  # ------------ TESTS ------------
  it 'POST /accesstoken' do
    access_token_response = pis_client.generate_token

    access_token = access_token_response['access_token']
    token_type = access_token_response['token_type']
    expires_in = access_token_response['expires_in']

    expect(access_token).not_to be_empty
    expect(token_type).not_to be_empty
    expect(token_type).to eq 'Bearer'
    expect(!expires_in.nil?).to be_truthy
  end
end
