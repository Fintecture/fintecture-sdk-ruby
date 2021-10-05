# frozen_string_literal: true

require 'json'
require 'fintecture/api/pis/settlements'

config = JSON.parse(File.read('./spec/api/pis/config.json'))

RSpec.describe Fintecture::Pis::Settlements do
  pis_client = Fintecture::PisClient.new({
    environment: config['environment'],
    app_id: config['app_id'],
    app_secret: config['app_secret'],
    private_key: config['private_key']
  })


  it 'GET /settlements' do
    pis_client.generate_token
    settlements_response = pis_client.settlements 

    meta = settlements_response['meta']
    data = settlements_response['data']
    links = settlements_response['links']

    expect(meta).not_to be_empty
    expect(links).not_to be_empty
  end

end
