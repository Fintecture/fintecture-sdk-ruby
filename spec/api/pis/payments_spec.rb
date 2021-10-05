# frozen_string_literal: true

require 'json'
require 'fintecture/api/pis/payments'

config = JSON.parse(File.read('./spec/api/pis/config.json'))

RSpec.describe Fintecture::Pis::Payments do
  pis_client = Fintecture::PisClient.new({
    environment: config['environment'],
    app_id: config['app_id'],
    app_secret: config['app_secret'],
    private_key: config['private_key']
  })

  payload_connect = {
    meta: {
      psu_name: 'John Doe', # Mandatory
      psu_email: 'sylvain.sanfilippo@fintecture.com', # Mandatory
      psu_phone: '666777888', # Mandatory
      psu_phone_prefix: '', # Optionnal
      psu_ip: '127.0.0.1', # Optionnal (Plante la signature)
      psu_form: '', # Mandatory - if no fixed beneficiary
      psu_incorporation: '', # Mandatory - if no fixed beneficiary
      psu_address: {
        street: 'Main St.', # Mandatory
        number: '123', # Optional
        complement: '2nd floor', # Optional
        city: 'Paris', # Mandatory
        zip: '75000', # Mandatory
        country: 'fr' # Mandatory
      }
    },
    data: {
      type: 'PIS',
      attributes: {
        amount: 123, # Mandatory
        currency: 'EUR', # Mandatory
        communication: 'Thanks Mom!', # Mandatory
        execution_date: '2021-09-23', # Optional
        # beneficiary: {      # Optional
        #     name: "Dummy SA", # Conditional
        #     iban: "FR1420041010050500013M02606", # Conditional
        #     swift_bic: "FTSBSESSXXX", # Conditional
        #     street: "road of somewhere", # Conditional
        #     number: "2", # Optional
        #     complement:"", # Optional
        #     city: "Paris", # Conditional
        #     zip: "93160", # Conditional
        #     country: "FR", # Conditional
        #     form: "", # Mandatory if no fixed beneficiary
        #     incorporation: "" # Mandatory if no fixed beneficiary
        # },
        debited_account_id: 'FR1420041010050500013M02606', # Optional
        debited_account_type: 'iban', # Mandatory if debited_account_id exist
        # end_to_end_id: '5f78e902907e4209aa8df63659b05d24',
        scheme: 'AUTO' # Optional
      }
    }
  }

  payload_request_to_pay = {
    meta: {
      psu_name: 'John Doe', # Mandatory
      psu_email: 'sylvain.sanfilippo@fintecture.com', # Mandatory
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
      cc: 'sylvain.sanfilippo@fintecture.com', # Optional
      bcc: 'sylvain.sanfilippo@fintecture.com' # Optional
    },
    data: {
      type: 'REQUEST_TO_PAY',
      attributes: {
        amount: 123, # Mandatory
        currency: 'EUR', # Mandatory
        communication: 'Thanks Mom!' # Mandatory
      }
    }
  }

  it 'GET /payments/[session_id] - Connect paiement' do
    pis_client.generate_token

    connect_response = pis_client.connect payload_connect, 'ok', 'https://www.google.fr', 'http://example.com/checkout?session=123'
    session_id = connect_response['meta']['session_id']

    payment_response = pis_client.payments session_id

    meta = payment_response['meta']
    data = payment_response['data']
    attributes = payment_response['data']['attributes']

    expect(meta['session_id']).to eq(session_id)
    expect(meta['status']).to eq('provider_required')
    expect(meta['code']).to eq(200)

    expect(meta['type']).to eq('PayByBank')
    expect(attributes['amount']).to eq('123')
    expect(attributes['currency']).to eq('EUR')
    expect(attributes['communication']).to eq('Thanks Mom!')
  end

  it 'GET /payments/[session_id] - Request-to-pay paiement' do
    pis_client.generate_token

    request_to_pay_response = pis_client.request_to_pay payload_request_to_pay, 'fr', 'https://www.google.fr'
    session_id = request_to_pay_response['meta']['session_id']

    payment_response = pis_client.payments session_id

    meta = payment_response['meta']
    data = payment_response['data']
    attributes = payment_response['data']['attributes']

    expect(meta['session_id']).to eq(session_id)
    expect(meta['status']).to eq('provider_required')
    expect(meta['code']).to eq(200)

    expect(meta['type']).to eq('RequestToPay')
    expect(attributes['amount']).to eq(123)
    expect(attributes['currency']).to eq('EUR')
    expect(attributes['communication']).to eq('Thanks Mom!')
  end

  it 'GET /payments/ ' do
    pis_client.generate_token

    request_to_pay_response = pis_client.request_to_pay payload_request_to_pay, 'fr', 'https://www.google.fr'
    session_id = request_to_pay_response['meta']['session_id']

    payment_response = pis_client.payments

    meta = payment_response['meta']
    data = payment_response['data']

    payment = data.detect { |payment| payment['meta']['session_id'] == session_id }

    attributes = payment['attributes']
    payment_meta = payment['meta']

    expect(payment_meta['status']).to eq('provider_required')

    expect(attributes['amount']).to eq(123)
    expect(attributes['currency']).to eq('EUR')
    expect(attributes['communication']).to eq('Thanks Mom!')
  end
end
