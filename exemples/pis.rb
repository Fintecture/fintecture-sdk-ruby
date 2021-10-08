# frozen_string_literal: true

require './lib/fintecture'

config = JSON.parse(File.read('./exemples/config_pis.json'))

pis_client = Fintecture::PisClient.new({
                                         environment: config['environment'],
                                         app_id: config['app_id'],
                                         app_secret: config['app_secret'],
                                         private_key: config['private_key']
                                       })

payload_connect = {
  meta: {
    psu_name: 'John Doe', # Mandatory
    psu_email: 'John.Doe@gmail.com', # Mandatory
    psu_phone: '666777888', # Mandatory
    psu_phone_prefix: '', # Optionnal
    psu_ip: '127.0.0.1', # Optionnal (Plante la signature)
    psu_form: '', # Mandatory - if no fixed beneficiary
    psu_incorporation: '', # Mandatory - if no fixed beneficiary
    psu_address: {
      street: 'Main St.', # Mandatory
      # number: '123', # Optional
      complement: '2nd floor', # Optional
      city: 'Paris', # Mandatory
      zip: '75000', # Mandatory
      country: 'fr' # Mandatory
    }
  },
  data: {
    type: 'PIS',
    attributes: {
      amount: '123', # Mandatory
      currency: 'EUR', # Mandatory
      communication: 'Thanks Mom!' # Mandatory
      # execution_date: '2021-09-31', # Optional
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

payload_request_to_pay = {
  meta: {
    psu_name: 'John Doe', # Mandatory
    psu_email: 'John.Doe@gmail.com', # Mandatory
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
    cc: 'John.Doe@gmail.com', # Optional
    bcc: 'John.Doe@gmail.com' # Optional
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

payload_initiate = {
  "meta": {
    "psu_name": 'Bob McCheese',
    "psu_email": 'John.Doe@gmail.com',
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

paramsProviders = {
  'filter[country]': 'FR',
  'filter[pis]': 'SEPA',
  'filter[ais]': 'Accounts',
  'filter[psu_type]': 'retail',
  'filter[auth_model]': 'redirect',
  'sort[name]': 'ASC',
  'sort[full_name]': 'ASC',
  'sort[country]': 'ASC',
  'sort[provider_id]': 'ASC'
}

# ######################## PIS ########################
# ------------ Get access token ------------
pis_client.generate_token
# ------------ Connect ------------
puts pis_client.connect payload_connect, 'ok', 'https://www.google.fr'
# ------------ Request to pay ------------
puts pis_client.request_to_pay payload_request_to_pay, 'fr', 'https://www.google.fr'
# ------------ Get payments ------------
puts pis_client.payments '7f47d3675f5d4964bc416b43af63b06e'
# ------------ Initiate ------------
puts pis_client.initiate payload_initiate, 'cmcifrpp', 'https://www.google.fr', 'ok'
# ------------ Refund ------------
puts pis_client.refund '7f47d3675f5d4964bc416b43af63b06e', 1
# ------------ settlements ------------
pis_client.settlements
pis_client.settlements '127335fdeb073e0eb2313ba0bd71ad44'
