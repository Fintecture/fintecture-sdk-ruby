# frozen_string_literal: true

require 'json'
require 'fintecture/api/pis/connect'

config = JSON.parse(File.read('./spec/api/pis/config.json'))

RSpec.describe Fintecture::Pis::Connect do
  pis_client = Fintecture::PisClient.new({
                                           environment: config['environment'],
                                           app_id: config['app_id'],
                                           app_secret: config['app_secret'],
                                           private_key: config['private_key']
                                         })
  
  def get_connect_payload(amount = "10", smart_transfer: false)
    payload = {
      meta: {
        psu_name: 'John Doe', # Mandatory
        psu_email: 'xavier.laumonier@fintecture.com', # Mandatory
        psu_phone: '666777888', # Mandatory
        # psu_phone_prefix: '', # Optionnal
        # psu_ip: '127.0.0.1', # Optionnal (Plante la signature)
        # psu_form: '', # Mandatory - if no fixed beneficiary
        # psu_incorporation: '', # Mandatory - if no fixed beneficiary
        # psu_address: {
        #   street: 'Main St.', # Mandatory
        #   number: '123', # Optional
        #   complement: '2nd floor', # Optional
        #   city: 'Paris', # Mandatory
        #   zip: '75000', # Mandatory
        #   country: 'fr' # Mandatory
        # }
      },
      data: {
        attributes: {
          amount: amount, # Mandatory
          currency: 'EUR', # Mandatory
          communication: 'Test Ruby Connect', # Mandatory
          # execution_date: '2021-09-23', # Optional
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
          # debited_account_id: 'FR1420041010050500013M02606', # Optional
          # debited_account_type: 'iban', # Mandatory if debited_account_id exist
          # end_to_end_id: '5f78e902907e4209aa8df63659b05d24',
          # scheme: 'AUTO' # Optional
        }
      }
    }
    reconciliation = {
      reconciliation: {
        level: 'payer'
      } 
    }
    payload[:meta] = payload[:meta].merge reconciliation if smart_transfer
    payload
  end

  it 'POST /connect' do
    pis_client.generate_token
    payload_connect = get_connect_payload "11"
    connect_response = pis_client.connect payload_connect, 'ok'

    meta = connect_response['meta']
    url = meta['url']
    session_id = meta['session_id']

    expect(url).not_to be_empty
    expect(session_id).not_to be_empty
  end

  it 'POST /connect + optional redirect_uri' do
    pis_client.generate_token
    payload_connect = get_connect_payload "12"
    connect_response = pis_client.connect payload_connect, 'ok', 'https://www.google.fr'

    meta = connect_response['meta']
    url = meta['url']
    session_id = meta['session_id']

    expect(url).not_to be_empty
    expect(session_id).not_to be_empty
  end

  it 'POST /connect + optional redirect_uri & origin_uri' do
    pis_client.generate_token
    payload_connect = get_connect_payload "13"
    connect_response = pis_client.connect payload_connect, 'ok', 'https://www.google.fr', 'http://example.com/checkout?session=123'

    meta = connect_response['meta']
    url = meta['url']
    session_id = meta['session_id']

    expect(url).not_to be_empty
    expect(session_id).not_to be_empty
  end

  it 'POST /connect + optional with_virtualbeneficiary' do
    pis_client.generate_token
    payload_connect = get_connect_payload "50", smart_transfer: true
    connect_response = pis_client.connect payload_connect, 'ok', with_virtualbeneficiary: true

    meta = connect_response['meta']
    url = meta['url']
    session_id = meta['session_id']
    virtual_beneficiary = connect_response['virtual_beneficiary']
    virtual_beneficiary_iban = virtual_beneficiary['iban']

    expect(url).not_to be_empty
    expect(session_id).not_to be_empty
    expect(virtual_beneficiary_iban).not_to be_empty
  end

  it 'POST /connect + optional redirect_uri & origin_uri & with_virtualbeneficiary' do
    pis_client.generate_token
    payload_connect = get_connect_payload "51", smart_transfer: true
    connect_response = pis_client.connect payload_connect, 'ok', 'https://www.google.fr', 'http://example.com/checkout?session=123', with_virtualbeneficiary: true

    meta = connect_response['meta']
    url = meta['url']
    session_id = meta['session_id']
    virtual_beneficiary = connect_response['virtual_beneficiary']
    virtual_beneficiary_iban = virtual_beneficiary['iban']

    expect(url).not_to be_empty
    expect(session_id).not_to be_empty
    expect(virtual_beneficiary_iban).not_to be_empty
  end
end
