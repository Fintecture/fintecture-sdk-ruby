# frozen_string_literal: true

require 'json'
require 'fintecture/api/ais/connect'

config = JSON.parse(File.read('./spec/api/ais/config.json'))
customer_id = config["customer_id"]
code = config["code"]

RSpec.describe Fintecture::Ais::Connect do
  ais_client = Fintecture::AisClient.new({
    environment: config['environment'],
    app_id: config['app_id'],
    app_secret: config['app_secret'],
    private_key: config['private_key']
  })


  it 'GET /connect' do
    connect_response = ais_client.connect "ok", "https://www.google.fr"

    connect_id = connect_response['meta']['connect_id']
    url = connect_response['meta']['url']


    expect(connect_id).not_to be_empty
    expect(url).not_to be_empty
  end

  
  it 'GET /connect + optional scope' do
    connect_response = ais_client.connect "ok", "https://www.google.fr", "accounts"

    connect_id = connect_response['meta']['connect_id']
    url = connect_response['meta']['url']

    expect(connect_id).not_to be_empty
    expect(url).not_to be_empty
  end

end
