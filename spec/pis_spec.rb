require 'json'
require 'fintecture/pis'

RSpec.describe Fintecture::Pis do

  
# Fintecture.environment = 'local'
# Fintecture.app_id = '4654b076-7ed5-43d2-9fb9-40d48b05bf92'
# Fintecture.app_secret = '2ab2eba3-7106-45a9-a0cc-3eda0d45ffc1'
# Fintecture.private_key = %q(-----BEGIN PRIVATE KEY-----
# MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCRzz6FzaNDUraa
# qh2vD7gqcGNskZOpEDTHiWqj7fXeirPDKbOPdwuRKjf+Dc2VFrzLs7sCGjv233ay
# xIMWGWVCXg2HvRfkF1qh+zlz09c7nY2C1TJ+jw5AkR90opCtcvVAt8N14GtwQPXX
# vCDw925/qIVU1JQHJsCS6XB10KWpdb+UzZxuZwruTw66+gx9njAyg9o/9mOIRJGQ
# fc2YTvlsfw+NiVQiwvjBrklXtN6cIiZIyH6PxhQg73zcceWlTqfokcxWl+wyZjIJ
# ReApYUPKihDAVDD+PKsv2j5J6/Bt0BQIfGCVVhqYqpcP5Xe+VMDyD5H2j3OYjjI5
# noiAdNvBAgMBAAECggEACpeUXPz6F2RqqSP4LGTxxdIh7tueb0F4TBHSojOhpk0g
# z5R3xlFpZjNmcOQIzgP3qrvqNwtigBsYpiuPXZYdBywKQz+R0jsowCvzWajccai5
# hHUUtMvonE55NgGvN+JqKDg75elryfJLdE9m0d/E8ldyzshIiUJ1P9bfGWKS/j3Y
# SQEqzmPfr8xPsmScxuwEH7qgobI1D0xCIU4dzMKj3sYxEN2XcSUyzQ7kMtvgVenQ
# gJ+o9xMc3pcmTB/v+u26l5PvMuUEq4SkepfOt8xXSCCYBEQYNdJgmD+AV0hhmqyJ
# NQbxl/OsYXdzkiPL+SEBt9z3i/iQ5XdoosbK3DeSaQKBgQDELuhbYPzgFeHSSlT5
# jMztP3C+H9rebC0S0o1owiQIdgOvt4Q/gB+TCvxnhSum7Bta5PrII5UW+35X/Q/G
# D61YchMpF5XmSsBT9mR1mxtQa+VfO3xeR6aOrS/nRhJodRsMZTaGx5oAuA/mw+zT
# 7L+A6IpKF5JahXlEygnt5GfUXQKBgQC+RGp+XhAs9c3mkqp6V7QbCZUqSTKzLJnD
# Cb6Tzd9El42MiRTYnzLBsehiXnuaTIyOnysOYZN+Tgw/KU6rj3racDOw/nzVxuJH
# 1K/JKX4A939JhbKK2e/TXVnyIdxMKj3b/Ud7/rBaF3X4IaIByheDJtoxFX+gvWNy
# edrU+D8utQKBgEuNYRCn9lr6MmCBHd6JOfZ4QxwFOo4EDQu9qJXahnP3tw252CV4
# WzCOv4vCfoAnV5WWr3naMjWKnyqVm7iEGxb/v59IpQLucMklD6U3GbrMAqa9SvUo
# FN3HlrYzhy1RRBxu8iPPxOBYAk+1zoQDHfEwHOnR0BwqYPx77nz+RHpFAoGBALMY
# gUmLzxwTEApeuhvJHF5q6b7RAelILUA6lupX2jadlX7Ytgel6sgKZ9zYZO576b6C
# MqwpywUUAFEf186Dkze0b+PF2Mn9mJfWqtTmupW8YlNZhxNOS4Igl/7kQpJrHKlL
# wxMDTQqwlLnJJs8aZIFue+nB+83ZF5f0/biEKC0VAoGAF5LVX7kBeYE8uYpgM3Of
# 4mDWpf6iBsZsWWLdz1KkTUQQe+1D75hCe9rnl9rHvw8MWQyjtxjCyI7W9ueF0f1l
# 0l9/4zNxstLm1eFNaMZIChYpNx7lIcBLwjuJkW+vIe1iQAOStGDbXOT+CmPk369b
# zS/9VwFGcJrUsVzzD40dhic=
# -----END PRIVATE KEY-----)
  
  
Fintecture.environment = 'test'
Fintecture.app_id = '8603fb08-d2ef-4e73-ba2f-5e4cd80efb65'
Fintecture.app_secret = '6c892fbb-15c1-42ec-9296-bbbdf89ffd5d'
Fintecture.private_key = %q(-----BEGIN PRIVATE KEY-----
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
-----END PRIVATE KEY-----)




payment_attrs_connect = {
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
  scheme: 'AUTO', # Optional
  customer_full_name: 'John Doe', # Mandatory
  customer_email: 'john.doe@email.com', # Mandatory
  customer_phone: '666777888', # Mandatory
  customer_phone_prefix: '', # Optionnal

  customer_ip: '127.0.0.1', # Optionnal (Plante la signature)
  customer_form: '', # Mandatory if no fixed beneficiary
  customer_incorporation: '', # Mandatory if no fixed beneficiary

  customer_address: { 
      street: 'Main St.', # Mandatory 
      number: '123', # Optional 
      complement: '2nd floor', # Optional 
      city: 'Paris', # Mandatory 
      zip: '75000', # Mandatory 
      country: 'fr' # Mandatory 
  },
  redirect_uri: 'http://www.google.fr', # Optional 
  origin_uri: 'http://example.com/checkout?session=123', # Optional 
  state: 'somestate' # Mandatory 
}
payment_attrs_request_to_pay = {
    x_language: 'fr', # Mandatory
    amount: 123, # Mandatory
    currency: 'EUR', # Mandatory
    communication: 'Thanks Mom!', # Mandatory
    # beneficiary: {      # Optional
    #     name: "Bob Smith", # Conditional
    #     iban: "FR1420041010050500013M02606", # Conditional
    #     swift_bic: "BANKFRXXXXX", # Conditional
    #     street: "road of somewhere", # Conditional
    #     number: "2", # Optional
    #     complement:"", # Optional
    #     city: "Paris", # Conditional
    #     zip: "93160", # Conditional
    #     country: "FR", # Conditional
    #     form: "", # Mandatory if no fixed beneficiary
    #     incorporation: "" # Mandatory if no fixed beneficiary
    # },

    customer_full_name: 'John Doe', # Mandatory
    customer_email: 'john.doe@email.com', # Mandatory
    customer_phone: '666777888', # Mandatory
    customer_phone_prefix: '+33', # Optionnal

    customer_address: { 
        street: 'Main St.', # Mandatory 
        number: '123', # Optional 
        complement: '2nd floor', # Optional 
        city: 'Paris', # Mandatory 
        zip: '75000', # Mandatory 
        country: 'fr' # Mandatory 
    },
    expirary: 86400, # Optional 
    cc: "sylvain.sanfilippo@fintecture.com", # Optional 
    bcc: "sylvain.sanfilippo@fintecture.com", # Optional 
}




  # ------------ TESTS ------------
  it "/accesstoken" do
    access_token_response = Fintecture::Pis.get_access_token

    access_token = access_token_response['access_token']
    token_type = access_token_response['token_type']
    expires_in = access_token_response['expires_in']

    expect(access_token).not_to be_empty
    expect(token_type).not_to be_empty
    expect(token_type).to eq 'Bearer'
    expect(!!expires_in).to be_truthy
  end


  it '/connect' do
    access_token_response = Fintecture::Pis.get_access_token
    access_token = access_token_response['access_token']

    connect_response = Fintecture::Pis.get_connect access_token, payment_attrs_connect
    connect_response_body = JSON.parse connect_response.body

    meta = connect_response_body["meta"]
    url = meta["url"]
    session_id = meta["session_id"]

    expect(connect_response.status).to eq(200)
    expect(url).not_to be_empty
    expect(session_id).not_to be_empty
  end

  it '/request-to-pay' do
    access_token_response = Fintecture::Pis.get_access_token
    access_token = access_token_response['access_token']

    request_to_pay_response = Fintecture::Pis.request_to_pay access_token, payment_attrs_request_to_pay
    request_to_pay_response_body = JSON.parse request_to_pay_response.body

    meta = request_to_pay_response_body["meta"]

    status = meta["status"]
    code = meta["code"]
    session_id = meta["session_id"]

    expect(status).to eq(201)
    expect(code).to eq("request_to_pay_initiated")
    expect(session_id).not_to be_empty
  end
  
  it '/payments/[session_id] - Connect paiement' do
    access_token_response = Fintecture::Pis.get_access_token
    access_token = access_token_response['access_token']

    connect_response = Fintecture::Pis.get_connect access_token, payment_attrs_connect
    connect_response_body = JSON.parse connect_response.body
    session_id = connect_response_body["meta"]["session_id"]

    payment_response = Fintecture::Pis.get_payments access_token, session_id
    payment_response_body = JSON.parse payment_response.body

    meta = payment_response_body['meta']
    data = payment_response_body['data']
    attributes = payment_response_body['data']['attributes']

    expect(meta['session_id']).to eq(session_id)
    expect(meta['status']).to eq('provider_required')
    expect(meta['code']).to eq(200)

    expect(meta['type']).to eq('PayByBank')
    expect(attributes['amount']).to eq("123")
    expect(attributes['currency']).to eq('EUR')
    expect(attributes['communication']).to eq("Thanks Mom!")
  end


  it '/payments/[session_id] - Request-to-pay paiement' do
    access_token_response = Fintecture::Pis.get_access_token
    access_token = access_token_response['access_token']

    request_to_pay_response = Fintecture::Pis.request_to_pay access_token, payment_attrs_request_to_pay
    request_to_pay_response_body = JSON.parse request_to_pay_response.body
    session_id = request_to_pay_response_body["meta"]["session_id"]

    payment_response = Fintecture::Pis.get_payments access_token, session_id
    payment_response_body = JSON.parse payment_response.body

    meta = payment_response_body['meta']
    data = payment_response_body['data']
    attributes = payment_response_body['data']['attributes']

    expect(meta['session_id']).to eq(session_id)
    expect(meta['status']).to eq('provider_required')
    expect(meta['code']).to eq(200)

    expect(meta['type']).to eq('RequestToPay')
    expect(attributes['amount']).to eq(123)
    expect(attributes['currency']).to eq('EUR')
    expect(attributes['communication']).to eq("Thanks Mom!")
  end


  it '/payments/ ' do
    access_token_response = Fintecture::Pis.get_access_token
    access_token = access_token_response['access_token']

    request_to_pay_response = Fintecture::Pis.request_to_pay access_token, payment_attrs_request_to_pay
    request_to_pay_response_body = JSON.parse request_to_pay_response.body
    session_id = request_to_pay_response_body["meta"]["session_id"]

    payment_response = Fintecture::Pis.get_payments access_token
    payment_response_body = JSON.parse payment_response.body

    meta = payment_response_body['meta']
    data = payment_response_body['data']

    payment = data.detect {|payment| payment['meta']['session_id'] == session_id}

    attributes = payment['attributes']
    payment_meta = payment['meta']

    expect(payment_meta['status']).to eq('provider_required')

    expect(attributes['amount']).to eq(123)
    expect(attributes['currency']).to eq('EUR')
    expect(attributes['communication']).to eq("Thanks Mom!")
  end


end
