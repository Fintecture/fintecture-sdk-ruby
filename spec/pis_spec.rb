require 'json'
require 'fintecture/pis'

RSpec.describe Fintecture::Connect do

  Fintecture.app_id = 'a229d811-0f17-4295-b135-99bb1cb2ca63'
  Fintecture.app_secret = 'a50afa3e-fea5-4bb8-86bd-b52c945fc0e8'
  Fintecture.private_key = %q(-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDI8ft2cX5Zos3X
PLT5/XlM6GYxAc122+fufVEKlMWIxZiSVfElhvznTa5jQPyTw5dshBZCZ6EZK/RT
oGZTrUC7EE6/ZI5gvVz6foVQHbpMIyGQ0dL2ne/2+gSxmOO3XtdIYQp7k0uINtUr
2Pbzi8n//FRj9TJqpQoHN1PB+UPBzjklis8o4pZctZ9HVpzb6vK8qga1L+ja+E7K
d9EdueV5Y29Uh7bPoGDGrFjZrQpcbvHEIvlvdMIabrpBu/4uzZ4f663as/vHDMDr
9zP4VOpZcME4D2UBiRiztbDQukgUQnYMudHfN6zuYIAig9eSI2sPQlgciUWJ+ryD
WkmwRozPAgMBAAECggEAV3+O6KdIxk0u5m8nusdVn1h+zw4i4oOk/WMR+9KGJSUt
Z2MGyzl5PFrF+bAdi1YaxITLkITBUE2kaRmqFPuW+R2DvLFTkepC50xaTmVzbp3J
it7ixsJE8D0z+AVD+t/QTFL9Fowv0pNVxW8HMUuIXPAJ6zCkkG1m7Xd5ADjC+UtF
QAaVHcAmz2lKRBCP9lzzCN2TfVpMGu71KcpaPXXhzuHWXsi2jEWyjvPajfLQvlQI
UVsLRJsNlz1PILslU/tuu2vASmpl7aWy+PxXGYTd7UOqeQ+es4xYpxmMfR2hhV4Y
OVOMRtqzmgh8QCEsuVfuA5sXxrksc/0J7iGXm2+SYQKBgQD9CoJmPt8KicQDkbsY
i6fjbhWOsVm1iWZJjXQR1XwsDmOmlK8gBfwHm2wFhaRt5G1jeo0/Trme4bKpvSOn
ddGJjJln3vk7TwcCquo/G7D+ZzB3IqL2FEqZqPFTTTu/eVHVtPXUurt4SpkZnzH+
1vt3YKKDq31e4auBIW+ZBbl2UQKBgQDLS4WGQTCVZleeQ02PbdSd2IcQL/4ye3ao
m6btC0GmrhhTd+rXdVdRRxxkkmnQDLVOnj05dCXOxtnhVMTsU+B4hUTNQvp8gW1c
BID5p08kvUOjSrfjkE5dIyp08H9cuFTuwL55sIvvs5NimJ8fWoaOCb1pgtzrVrl7
o40uRCppHwKBgQCPUWd//7YWYucZWm4MvfTONKiTFFIKJxM/L5YBD9hvn4rDa80w
pxMTP+1Tx1jVQR7PzDa6F528pnqp9s196JZQgMjWcwzYka8XzLQ2IDoELW/e2khQ
dje2hmCA3OqtTUqTbxYZcdYCkMXcJDWN8Denap1BVF0C43BfCBAMLJjZsQKBgFRl
UtZMY+Xx6bfrCtzbZKPuywteUTIV7UnL7H2F6chPiAvGwbiWnxw/4DqkScc0L2Sm
7pXWcQepp7QS4/mUTKDb+pcYEjLz7DmCKST7XzDKXbUBhNu1AcNKoQqQ+N6+K4w+
ehS8xStKqooJAC4c/7Uht/+Ac0RD6Za5bBfj9pNTAoGAGHiUKyN/wB5joM6/K7bm
StLwtZclgd2jkqPp5yuhmSpXPkQmEePhWrHuEx2pF6hdSvI1RRydNgTn0YmpB0bM
WDQPSNRwcsKTJVM2qb6Xx2ziBhGZf1vdyYLlin+vigoWgGg5xUAsUG0cGbloZ/dB
WosgDj9AGW6w4ETDnTGCA1Q=
-----END PRIVATE KEY-----)

  Fintecture.environment = 'sandbox'

  payload_attr = {
      data: {
          type: 'PIS',
          attributes: {
              amount: 125,
              currency: 'EUR',
              communication: "Thank's mom",
              end_to_end_id: '5f78e902907e4209aa8df63659b05d24'
          }
      },
      meta: {
          psu_name: 'Test bot',
          psu_email: 'email@test.com',
          psu_ip: '192.168.0.1'
      }
  }

  it "get access token" do
    access_token_response = Fintecture::Pis.get_access_token

    access_token = access_token_response['access_token']
    token_type = access_token_response['token_type']
    expires_in = access_token_response['expires_in']

    expect(access_token).not_to be_empty
    expect(token_type).not_to be_empty
    expect(token_type).to eq 'Bearer'
    expect(!!expires_in).to be_truthy
  end

  it 'prepare payment' do
    access_token_response = Fintecture::Pis.get_access_token

    access_token = access_token_response['access_token']

    prepare_response = Fintecture::Pis.prepare_payment access_token, payload_attr
    prepare_response_body = JSON.parse prepare_response.body

    meta = prepare_response_body['meta']

    expect(meta['session_id']).not_to be_empty
    expect(meta['status']).to eq('provider_required')
    expect(meta['title']).to eq('Payment Prepared')
    expect(meta['code']).to eq(201)

  end

  it 'get payments' do
    access_token_response = Fintecture::Pis.get_access_token

    access_token = access_token_response['access_token']

    prepare_response = Fintecture::Pis.prepare_payment access_token, payload_attr
    prepare_response_body = JSON.parse prepare_response.body

    session_id = prepare_response_body['meta']['session_id']

    payment_response = Fintecture::Pis.get_payments access_token, session_id
    payment_response_body = JSON.parse payment_response.body

    meta = payment_response_body['meta']
    data = payment_response_body['data']
    attributes = payment_response_body['data']['attributes']

    expect(meta['session_id']).not_to be_empty
    expect(meta['status']).to eq('provider_required')
    expect(meta['code']).to eq(200)

    expect(data['type']).to eq('PIS')
    expect(attributes['amount']).to eq(125)
    expect(attributes['currency']).to eq('EUR')
    expect(attributes['communication']).to eq("Thank's mom")
    expect(attributes['end_to_end_id']).to eq('5f78e902907e4209aa8df63659b05d24')
  end
end
