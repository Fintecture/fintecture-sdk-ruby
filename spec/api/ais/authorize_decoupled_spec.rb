# frozen_string_literal: true

require 'json'
require 'fintecture/api/ais/authorize_decoupled'

config = JSON.parse(File.read('./spec/api/ais/config.json'))
customer_id = config['customer_id']
code = config['code']

RSpec.describe Fintecture::Ais::AuthorizeDecoupled do
  ais_client = Fintecture::AisClient.new({
                                           environment: config['environment'],
                                           app_id: config['app_id'],
                                           app_secret: config['app_secret'],
                                           private_key: config['private_key']
                                         })

  it 'GET /authorize - Token auth' do
    ais_client.generate_token code

    authorize_response = ais_client.authorize_decoupled app_id_auth: false, provider_id: 'agfbfr', polling_id: '1234'

    expect(authorize_response['provider']).to eq('agfbfr')
    expect(authorize_response['status']).not_to be_empty
  end

  it 'GET /authorize - Code auth' do
    ais_client.generate_token code

    authorize_response = ais_client.authorize_decoupled app_id_auth: true, provider_id: 'agfbfr', polling_id: '1234'

    expect(authorize_response['provider']).to eq('agfbfr')
    expect(authorize_response['status']).not_to be_empty
  end
end
