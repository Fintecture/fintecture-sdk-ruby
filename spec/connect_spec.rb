require 'json'
require 'fintecture/pis'
require 'fintecture/connect'
require 'fintecture/exceptions'

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
  public_key_str = %q(-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyPH7dnF+WaLN1zy0+f15
TOhmMQHNdtvn7n1RCpTFiMWYklXxJYb8502uY0D8k8OXbIQWQmehGSv0U6BmU61A
uxBOv2SOYL1c+n6FUB26TCMhkNHS9p3v9voEsZjjt17XSGEKe5NLiDbVK9j284vJ
//xUY/UyaqUKBzdTwflDwc45JYrPKOKWXLWfR1ac2+ryvKoGtS/o2vhOynfRHbnl
eWNvVIe2z6BgxqxY2a0KXG7xxCL5b3TCGm66Qbv+Ls2eH+ut2rP7xwzA6/cz+FTq
WXDBOA9lAYkYs7Ww0LpIFEJ2DLnR3zes7mCAIoPXkiNrD0JYHIlFifq8g1pJsEaM
zwIDAQAB
-----END PUBLIC KEY-----)
  Fintecture.environment = 'sandbox'


  payment_attrs = {
      amount: 125,
      currency: 'EUR',
      customer_full_name: 'Test bot',
      customer_email: 'email@test.com',
      customer_ip: '192.168.0.1',
      end_to_end_id: '5f78e902907e4209aa8df63659b05d24',
      redirect_uri: 'http://example.com/callback',
      origin_uri: '',
      state: 'bob',
      communication: '1'
  }

  callback_params = {
      session_id: 'session_id',
      status: 'status',
      customer_id: 'customer_id',
      provider: 'provider',
      state: 'state'
  }

  before(:each) do
    access_token_response = Fintecture::Pis.get_access_token

    @access_token = access_token_response['access_token']
  end
  
  it "generate a correct URL" do
    mock_url = "#{Fintecture::Api::BaseUrl::FINTECTURE_CONNECT_URL[Fintecture.environment.to_sym]}/pis?state="
    url_response = Fintecture::Connect.get_pis_connect(@access_token, payment_attrs)

    expect(url_response[:url]).to include mock_url
  end

  it '#PIS get_pis_connect Error no amount' do
    test_payment_attrs = payment_attrs.clone
    test_payment_attrs.delete(:amount)

    expect { Fintecture::Connect.get_pis_connect(@access_token, test_payment_attrs) }.to raise_error(Fintecture::ValidationException, 'amount is a mandatory field')
  end

  it '#PIS get_pis_connect Error end_to_end_id no alphanumerical' do
    test_payment_attrs = payment_attrs.clone
    test_payment_attrs[:end_to_end_id] = 'ajlnca@'

    expect { Fintecture::Connect.get_pis_connect(@access_token, test_payment_attrs) }.to raise_error(Fintecture::ValidationException, 'end_to_end_id must be an alphanumeric string')
  end

  it '#PIS get_pis_connect Error no currency' do
    test_payment_attrs = payment_attrs.clone
    test_payment_attrs.delete(:currency)

    expect { Fintecture::Connect.get_pis_connect(@access_token, test_payment_attrs) }.to raise_error(Fintecture::ValidationException, 'currency is a mandatory field')
  end

  it 'verify_url_parameters should be true' do
    # Generate encrypt

    callback_params_test = {app_id: Fintecture.app_id, app_secret: Fintecture.app_secret}.merge(callback_params)
    plainText = callback_params_test.map {|key, value| "#{key}=#{value}"}.join('&')

    digestHash = Base64.strict_encode64(Digest::SHA256.digest(plainText))

    public_key = OpenSSL::PKey::RSA.new(public_key_str)
    digest = public_key.public_encrypt digestHash, OpenSSL::PKey::RSA::PKCS1_OAEP_PADDING
    # End Generate encrypt
    callback_params_test[:s] = Base64.strict_encode64(digest)
    response = Fintecture::Connect.verify_url_parameters callback_params_test

    expect(response).to be_truthy
  end

  it 'verify_url_parameters invalid param type' do
    expect { Fintecture::Connect.verify_url_parameters 'param' }.to raise_error(Fintecture::ValidationException, 'invalid parameter format, the parameter should be a Hash or an Object Model instead a String')
  end

  it 'verify_url_parameters Error no digest' do
    callback_params_test = {app_id: Fintecture.app_id, app_secret: Fintecture.app_secret}.merge(callback_params)

    expect { Fintecture::Connect.verify_url_parameters callback_params_test }.to raise_error(Fintecture::ValidationException, 'invalid post payment parameter s')
  end

  it 'verify_url_parameters Error no session_id' do
    callback_params_test = {app_id: Fintecture.app_id, app_secret: Fintecture.app_secret, s: 's'}.merge(callback_params)
    callback_params_test.delete(:session_id)

    expect { Fintecture::Connect.verify_url_parameters callback_params_test }.to raise_error(Fintecture::ValidationException, 'invalid post payment parameter session_id')
  end

  it 'verify_url_parameters Error no status' do
    callback_params_test = {app_id: Fintecture.app_id, app_secret: Fintecture.app_secret, s: 's'}.merge(callback_params)
    callback_params_test.delete(:status)

    expect { Fintecture::Connect.verify_url_parameters callback_params_test }.to raise_error(Fintecture::ValidationException, 'invalid post payment parameter status')
  end

  it 'verify_url_parameters Error no customer_id' do
    callback_params_test = {app_id: Fintecture.app_id, app_secret: Fintecture.app_secret, s: 's'}.merge(callback_params)
    callback_params_test.delete(:customer_id)

    expect { Fintecture::Connect.verify_url_parameters callback_params_test }.to raise_error(Fintecture::ValidationException, 'invalid post payment parameter customer_id')
  end

  it 'verify_url_parameters Error no provider' do
    callback_params_test = {app_id: Fintecture.app_id, app_secret: Fintecture.app_secret, s: 's'}.merge(callback_params)
    callback_params_test.delete(:provider)

    expect { Fintecture::Connect.verify_url_parameters callback_params_test }.to raise_error(Fintecture::ValidationException, 'invalid post payment parameter provider')
  end
end
