# frozen_string_literal: true

require 'json'
require 'fintecture/api/pis/initiate'

config = JSON.parse(File.read('./spec/api/pis/config.json'))

RSpec.describe Fintecture::Pis::Initiate do
  pis_client = Fintecture::PisClient.new({
    environment: config['environment'],
    app_id: config['app_id'],
    app_secret: config['app_secret'],
    private_key: config['private_key']
  })

  payload_initiate = {
    "meta": {
      "psu_name": 'Bob McCheese',
      "psu_email": 'sylvain.sanfilippo@fintecture.com',
      "psu_phone": '09743593535',
      "psu_address": {
        "street": 'route de la france',
        "number": '33',
        "complement": '2nd floor',
        "zip": '12001',
        "city": 'Paris',
        "country": 'FR'
      }
    },
    "data": {
      "type": 'PIS',
      "attributes": {
        "amount": '149.30',
        "currency": 'EUR',
        "communication": 'Order 6543321'
        # "beneficiary": {
        #     "name": "Bob Smith",
        #     "street": "road of somewhere",
        #     "number": "2",
        #     "city": "Paris",
        #     "zip": "93160",
        #     "country": "FR",
        #     "iban": "FR1420041010050500013M02606",
        #     "swift_bic": "BANKFRXXXXX"
        # }
      }
    }
  }

  it 'POST /initiate' do
    pis_client.generate_token
    initiate_response = pis_client.initiate payload_initiate, 'cmcifrpp', 'https://www.google.fr'
    data = initiate_response['data']
    meta = initiate_response['meta']

    expect(meta['provider']).to eq('cmcifrpp')
    expect(data['type']).to eq('PIS')
  end

  it 'POST /initiate + optionals state' do
    pis_client.generate_token
    initiate_response = pis_client.initiate payload_initiate, 'cmcifrpp', 'https://www.google.fr', 'ok'
    data = initiate_response['data']
    meta = initiate_response['meta']

    expect(meta['provider']).to eq('cmcifrpp')
    expect(data['type']).to eq('PIS')
  end
end
