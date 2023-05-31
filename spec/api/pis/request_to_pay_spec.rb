# frozen_string_literal: true

require 'json'
require 'fintecture/api/pis/request_to_pay'

config = JSON.parse(File.read('./spec/api/pis/config.json'))

RSpec.describe Fintecture::Pis::RequestToPay do
  pis_client = Fintecture::PisClient.new({
                                           environment: config['environment'],
                                           app_id: config['app_id'],
                                           app_secret: config['app_secret'],
                                           private_key: config['private_key']
                                         })

  payload_request_to_pay = {
    meta: {
      psu_name: 'John Doe', # Mandatory
      psu_email: 'xavier.laumonier@fintecture.com', # Mandatory
      psu_phone: '666777888', # Mandatory
      psu_phone_prefix: '+33', # Optionnal
      psu_address: {
        street: 'Main St.', # Mandatory
        number: '123', # Optional
        city: 'Paris', # Mandatory
        zip: '75000', # Mandatory
        country: 'fr' # Mandatory
      },
      expirary: 86_400, # Optional
      cc: 'xavier.laumonier@fintecture.com', # Optional
      bcc: 'xavier.laumonier@fintecture.com' # Optional
    },
    data: {
      type: 'REQUEST_TO_PAY',
      attributes: {
        amount: "123", # Mandatory
        currency: 'EUR', # Mandatory
        communication: 'Thanks Mom!' # Mandatory
      }
    }
  }

  it 'POST /request-to-pay' do
    pis_client.generate_token

    request_to_pay_response = pis_client.request_to_pay payload_request_to_pay, 'fr'
    meta = request_to_pay_response['meta']

    status = meta['status']
    code = meta['code']
    session_id = meta['session_id']

    expect(status).to eq(201)
    expect(code).to eq('request_to_pay_initiated')
    expect(session_id).not_to be_empty
  end

  it 'POST /request-to-pay + optional redirect_uri' do
    pis_client.generate_token

    request_to_pay_response = pis_client.request_to_pay payload_request_to_pay, 'fr', 'https://www.google.fr'
    meta = request_to_pay_response['meta']

    status = meta['status']
    code = meta['code']
    session_id = meta['session_id']

    expect(status).to eq(201)
    expect(code).to eq('request_to_pay_initiated')
    expect(session_id).not_to be_empty
  end
end
