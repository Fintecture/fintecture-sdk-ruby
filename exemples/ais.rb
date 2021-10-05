# frozen_string_literal: true

require './lib/fintecture'



# ------------ Test class -------------
ais_client = Fintecture::AisClient.new({
    environment: 'local',
    app_id: '8bd5204a-e467-4d87-86b6-5db5a45a1ea7',
    app_secret: '9404e1c8-e4c3-422e-9bfb-bb3636af5c2e',
    private_key: '-----BEGIN PRIVATE KEY-----
MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDzaeynrY+ZRcob
peMp08MwSGqmnsovffxe6f7P7DXi6quBWGf277gREIfc9Q7aJvYpnSH5+KslhQ2V
W5w9oHZCcNGQJSuoxsjaVCUSZBByMQrzxqFtQp4ETjsMbDA85x/XFmfJSFciaU46
jdoHYeSb+iGmpG8Uh3uWcZtbxKD7WyoJZHvWJ4DHWzYzTKbfkez2hQDZunMYZnSi
Yjndzwxol/kudmedWvaDTyCIxdXn6KgLrdwz0VgRIQS+0d9bn+IpX+AnH+ITUPm5
2zh1bjMCw6o2S3J5yf2XmGm/+9JfUK1hFJmNI8Y8Zf7IyhTzcJm+96RKSx12khtP
fkrQEh3FAgMBAAECggEAF/X7GwVpf43AZ6jUe/tRuTjDsNusLPEirOgtUmPe6ROv
JsggUc1Gqf1d1mkUGXLg4/dJDy2EkWivzd5K+sEHKyKmamFSUyagQmeqj40klk0Q
Fi+dF9+JJQTbaK1ksTYSKw7UUBrMIwHJNtfcWMIw6g69DcWdfqCYkJZl0+p+60cc
rn5eIw1t5ODlZpETPuvKYfG+VARidpK+e5aBh3B81+kDxupor2Xb/vV9nhpKICng
AXlFJb277dMEcrKDtrwa21gAm0Y5FpJKSyBq+uiOfW7HMNtnIS6jE8gX8PkL4Tec
Zp06H3RL+Qw9jIYAKvxL8ocAq518HuBGV8BYyLOwIQKBgQD62XzjgtGQVePQTLQR
4hB9c1JMFDhFMX/CAwUe7rK0V4MDEL+Om4OvRJcGXjhlOZBieComAJcssv3iRtMt
a42nK0nAjqDIOxYKGXqBQ8kSDzfkP9nHRHSNxDE0WPgwhy4hFUzlJzAj024n0zMy
G7QL3+BVcBGJms6I2u11FpNTpQKBgQD4aVpICqeyWSEyeVyZjcnsSLEInBd28t33
JoWWHB6f2x6i7M715006YBUfzqwGroX6n1vOcgyEpoKFGa6ANL+eShfpPWml82/t
Vo96FIvss0AI68uooChbgHXkYOndTDIohqTD1l1e4IWwnabPmO5O9lY/AS/L5TFQ
hbNyP80HoQKBgBOeyzvoUYfej/EM7tCvQ+bsDDXTJwuScZG1NsNSnDuq1J56wuDe
nRAqZz2iRPr146swBuvuA+UFIwJ906qrzOqUYjJjdYPzyyeDEqflq2Z0NkTuEZSa
cBteixKzGsaA7ES+K8OIqyVCNk17IXf73rtHCX7lQxnmN91Qcl5EI8XZAoGAU7Mb
yl5ctsk1WE5wFwUhXk336JC/j0Kx6469QCDlaLNqFTd5XH29Fcg+FeOLLw0q85Ey
W9MtyJxaKgLHO0eKsQkCGYKp0FLACdY6rcWyh+S11MuuaXjdYEdecb79zaTY2bLU
XXAjMc6w/RuBkz1SPqTd1ojN1AO7pAgIuJwqt0ECgYA+o2ypfYiORB+M5iG0fDtK
MJCzv9oIl2bm0rcBhx2QwdjeTZAQArz9hX4oPkIXmscQoJ+MBxbPXvm8hvFtdvAx
6bbbJz6n0+7RXwYkH9RMk/75AQsxBlYqKyV13PK7Fber8mmUKlmPXel47aig6Shf
SmAi2hLOJo+3ntNJFx1fEQ==
-----END PRIVATE KEY-----'
  })

# ######################## AIS ########################

# ------------ Connect ------------
connect_response = ais_client.connect "ok", "https://www.google.fr"
connect_id = connect_response['meta']['connect_id']
url = connect_response['meta']['url']


puts "Connect url => #{url}"

# Put the return of connect url here
customer_id = "c84e6a2c66862f6ce169a11262b28f4c"
code = "173535d0acc16271e7942cc6e1772a5b"



# ------------ Get access token ------------
ais_client.generate_token code
ais_client.generate_refresh_token
# ------------ Authorize ------------
puts ais_client.authorize app_id_auth: true, provider_id: "agfbfr", redirect_uri: "https://www.google.fr", state: "ok", x_psu_id: nil, x_psu_ip_address: nil
# ------------ Authorize decoupled ------------
puts ais_client.authorize_decoupled app_id_auth: false, provider_id: "agfbfr", polling_id: "1234"
# ------------ Get accounts ------------
accounts_response = ais_client.accounts customer_id: customer_id, account_id: nil, remove_nulls: nil, withBalances: nil
account = accounts_response['data'].first
account_id = account['id']
# ------------ Get transactions ------------
transactions_filters = {
  "filter[date_to]": "2020-01-01",
  'filter[date_from]': "max"
}
transactions_response = ais_client.transactions customer_id: customer_id, account_id: account_id, remove_nulls: true, convert_dates: true, filters: transactions_filters
transaction = transactions_response['data'].first
puts transaction
# ------------ Get account holders ------------
# Caution the hasAccountholders field in db must have a value = 1.
puts ais_client.account_holders customer_id: customer_id, remove_nulls: nil
# ------------ Delete customer ------------
# Customer not found if customer you don't use the api before
puts ais_client.delete_customer customer_id: customer_id
 
