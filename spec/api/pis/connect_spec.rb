# frozen_string_literal: true

require 'fintecture/api/pis/connect'

RSpec.describe Fintecture::Pis::Connect do
  pis_client = Fintecture::PisClient.new({
                                           environment: 'test',
                                           app_id: '8603fb08-d2ef-4e73-ba2f-5e4cd80efb65',
                                           app_secret: '6c892fbb-15c1-42ec-9296-bbbdf89ffd5d',
                                           private_key: '-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmfvSia9VTtjMt
iFHAP4cE2VYHKGoG+NRz5ciYbsI41jh3eSVwA6aFmOZBb0gXMEvCQZZeNWe4/2LO
tt3BJLQw9jcLnFQ0P8lhJv4octf+CSLFM34WTkSImsDiKpUgbbo7BUaqYzRShUAc
SjXlP5zUL7z0a99pPnXAFQzV66vyeVa0IoP2cSbFYAfAY9mp/5lbJQvOsXLA/ay9
mTNk1u21OFLYfzuta+WJRhFJc05Prb21hd2+Yk+A7S1MkMbFCw5r8rXN9E9iVFcn
BBPveDGDfSC29n4ZMD/xPjfALXzkfBhukeJwHEIVFhBr3CkVUtSZOpA+Wl4zCGJx
QknJKOM7AgMBAAECggEAOUSFxLAuikKrS8gNxoCTYnmW+5NNFOTVvp+U5cmDCKW2
enGzDNpUlrNGz88FDuTPyhthKzpXWOyPAecoU1zaldS6jkXROL+P9tjApw0JehmO
WiIiBm4ZaJtCKQjYjnTvj4l7CvRgdNnceV6VNyswOFPLPI82Iy8WtWEILzSGyjmg
Fsrw7WpCKSgzfenoI0Lnz6osQnRf5vHpWqm/NSX4qPuhDsODLI60Z9v2FehTvR8J
JgHtXm6Eb3jfQh2VunLWFCv0zG9qT1jOATfRZXiEUozwBaX925d8yADqPMjl56vc
1tyb6L+EDxPBubUzqkwc5t9HuWtlwQfJRAaAfcRNgQKBgQDWZHNBZu7lMlf7VlCt
ccKu6hcGl0WxWAqaD6dnTIfu4x96zHjypDBHvtKTgTcOun048Lwwx+10DDUbOcPw
uFOU7uEoitfL8l3S41ah5dCVulfHMSRqZBUmnKQIgh2gQYAW4MpzzK3yOfC3QdKn
UQjJ7C2thPgwr5FVn85RXjPD2wKBgQDGzuOplVr3mq6Bf9dHDalhs7ICnrxiFy8r
KGDvJ2ZBfuU9OsjS/rfS3XU32Y+QcqgfgGiykZyBK9ciR4fQB8JB4BMnRo+0wv1W
hRIaax4sbwdLLx/UaR109g0E/9Z1N5lnByoW4c7Jy9bdf0Ti3wZvCMOVYL54gez/
Ar5CXmksIQKBgDtnY+QYUFNjaqtylDIq1kW/CRhDbAUinvVnJvxhYTzY480TwOOC
iPooLpK+d/H1zGKtmYduriW8iC5+CAO4HziiI/Mm3XpeMo8PfN6pHe2Oz2ma/TsZ
dh7Xwj+1Rd40p/gu2wnRCdWXJlKww1ynAGdqsJFmyZo722o9OF6lWnSHAoGAH7D1
K6BKWvQGY1BMsd/ko1Vwx+gj4YMOmtOZ+CWQsFoZEtSfFLtT9EInIFsG/qC4WiUv
C2AY0aJ6bdV3OdsyxSuCAh3GZKs8lSErTJjMu4qLYBnH+iUzc+SRGL3ros3VH05O
EE24mARtYOubwIqKzQJZoyND2ZPkgpYeXBgOreECgYEAg0+lcBaN02yalOLalCDz
yBda7xpfvnEYv1VUK/Hb4g9hD8KBciTr1OZo82Mjv7uC0ToBq9vDFmVXV4AbIIl7
z/ZLU1tK4wJqXqKBEz+mzapJZpo9tzxrg7pg8VJG/a58fplraTchL6N6PFL/DEY9
02CGyNOpy9nTApObcTv1sPw=
-----END PRIVATE KEY-----'
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


  it '/connect' do
    pis_client.generate_token
    connect_response = pis_client.connect payload_connect, 'ok'

    meta = connect_response['meta']
    url = meta['url']
    session_id = meta['session_id']

    expect(url).not_to be_empty
    expect(session_id).not_to be_empty
  end

  
  it '/connect + optional redirect_uri' do
    pis_client.generate_token
    connect_response = pis_client.connect payload_connect, 'ok', 'https://www.google.fr'

    meta = connect_response['meta']
    url = meta['url']
    session_id = meta['session_id']

    expect(url).not_to be_empty
    expect(session_id).not_to be_empty
  end

  it '/connect + optional redirect_uri & origin_uri' do
    pis_client.generate_token
    connect_response = pis_client.connect payload_connect, 'ok', 'https://www.google.fr', 'http://example.com/checkout?session=123'

    meta = connect_response['meta']
    url = meta['url']
    session_id = meta['session_id']

    expect(url).not_to be_empty
    expect(session_id).not_to be_empty
  end
end