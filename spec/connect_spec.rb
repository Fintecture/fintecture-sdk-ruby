RSpec.describe Fintecture::Connect do

  Fintecture.app_id = '65bfee30-1b5d-4687-83c7-286fb459feda'
  Fintecture.app_secret = '66c41ebf-877d-40c9-9285-4485ebb27a76'
  Fintecture.app_private_key = %q(-----BEGIN RSA PRIVATE KEY-----
MIICXAIBAAKBgQCTiulmDq1iK1QIKHbVf3VHczHsd28gFfQJ3kAGq35cHgMgblwL
S33ghNeeSN+Pix8MzqSII/4VU0t4pEue8XdWEUuvTXgLRia+Toca8on1MVOHU9OB
4M18bDnA4wn19Krq/ac9i2/r8xLtxuf2ysR+gu9Btq4hdFD19BJIy/d90QIDAQAB
AoGAZBOULtKDzpO/Iu13dWdIAJflZBS6/pOFfXAQE7YdNpRw4H2a11p0Xmcc7dNW
OMJP5FsCBQoM3SArkAA4/u2gWGhuNOG56ARUp1rygqPEWNeE/Uwb0ugyjzKy3El4
b5JG8ycumz+SnBPNH+l6GZo/Lst7hIaq4PXm0umT8C28LrUCQQDl7OVTHrn/us40
5uLYTDFboXA6Dn51MDmj3KNGyTpwYRCsKwuQlmABo8ZC6wfnG1BAjj8hRz5+/QoR
yZWyoG1fAkEApEZP1/+SiJH1vA5gqqJPzLOE/cNt+KQfiWm3WQrdE1Gusx9ttE3f
XTGDSSqohnFjaPeslcMrTvvFaYbSea2yzwJADPPnh2M3vzxa2YgYR28jaLITjHG8
lgV9ecm4OQilDieptMlIAYE3L2B2jtaGv3I+dySMUeedkbHXm2Dr2gBHqQJBAIcZ
tEyFyXM75wbUJDfw6QQGl9dDREv6Xl1abgly38IlqTFzJXvll09Dix8/T/3Rftoy
5uL78cAxW3egA7VCXw0CQF9UZbuTNesf8bDXVfohbtVDXOBZz/5EKI8vGyWLpA2n
xC2v8Z0vrPs7JN8R9d2bpqZzP1AU0pMAoEKcS66S+UM=
-----END RSA PRIVATE KEY-----)
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
  public_key_str = %q(-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCTiulmDq1iK1QIKHbVf3VHczHs
d28gFfQJ3kAGq35cHgMgblwLS33ghNeeSN+Pix8MzqSII/4VU0t4pEue8XdWEUuv
TXgLRia+Toca8on1MVOHU9OB4M18bDnA4wn19Krq/ac9i2/r8xLtxuf2ysR+gu9B
tq4hdFD19BJIy/d90QIDAQAB
-----END PUBLIC KEY-----)
  
  it "generate a correct URL" do
    mock_url = "#{Fintecture::Api::BaseUrl::FINTECTURE_CONNECT_URL[Fintecture.environment.to_sym]}/pis?state=eyJhcHBfaWQiOiI2NWJmZWUzMC0xYjVkLTQ2ODctODNjNy0yODZmYjQ1OWZlZGEiLCJhY2Nlc3NfdG9rZW4iOm51bGwsInNpZ25hdHVyZV90eXBlIjoicnNhLXNoYTI1NiIsInNpZ25hdHVyZSI6Imh5QmZIb21FYURsMXJSUk9RVzVQdE9sUnpJSUlNc2pZdjBYdDkrSkd3ZmpUVTlhZHpkaENvZmxINEpCcFM1Y05PUGNmSFpTZ1VyQ3pkSXZaOGNNWE50ZkFIUklRNFVjV2VjVk11YXdDVTVRN2VSbmZHNGo2MlQrelZFTnpvOEoyRmJKUUIwRDJ3SFBwTFR2ZE5mRmU4M2pvWE5UbGZ3RWhFMzkzcjJ5N0VHND0iLCJyZWRpcmVjdF91cmkiOiJodHRwOi8vZXhhbXBsZS5jb20vY2FsbGJhY2siLCJvcmlnaW5fdXJpIjoiIiwic3RhdGUiOiJib2IiLCJwYXlsb2FkIjp7ImRhdGEiOnsidHlwZSI6IlBBWU1FTlQiLCJhdHRyaWJ1dGVzIjp7ImFtb3VudCI6MTI1LCJjdXJyZW5jeSI6IkVVUiIsImNvbW11bmljYXRpb24iOiIxIiwiZW5kX3RvX2VuZF9pZCI6IjVmNzhlOTAyOTA3ZTQyMDlhYThkZjYzNjU5YjA1ZDI0In19LCJtZXRhIjp7InBzdV9uYW1lIjoiVGVzdCBib3QiLCJwc3VfZW1haWwiOiJlbWFpbEB0ZXN0LmNvbSIsInBzdV9pcCI6IjE5Mi4xNjguMC4xIn19LCJ2ZXJzaW9uIjoiMC4xLjUifQ=="
    url = Fintecture::Connect.connect_url_pis(payment_attrs)

    expect(mock_url).to eq url
  end

  it '#PIS connect_url_pis Error no amount' do
    test_payment_attrs = payment_attrs.clone
    test_payment_attrs.delete(:amount)

    expect { Fintecture::Connect.connect_url_pis(test_payment_attrs) }.to raise_error('amount is a mandatory field')
  end

  it '#PIS connect_url_pis Error end_to_end_id no alphanumerical' do
    test_payment_attrs = payment_attrs.clone
    test_payment_attrs[:end_to_end_id] = 'ajlnca@'

    expect { Fintecture::Connect.connect_url_pis(test_payment_attrs) }.to raise_error('end_to_end_id must be an alphanumeric string')
  end

  it '#PIS connect_url_pis Error no currency' do
    test_payment_attrs = payment_attrs.clone
    test_payment_attrs.delete(:currency)

    expect { Fintecture::Connect.connect_url_pis(test_payment_attrs) }.to raise_error('currency is a mandatory field')
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
    expect { Fintecture::Connect.verify_url_parameters 'param' }.to raise_error('invalid parameter format, the parameter should be a Hash or an Object Model instead a String')
  end

  it 'verify_url_parameters Error no digest' do
    callback_params_test = {app_id: Fintecture.app_id, app_secret: Fintecture.app_secret}.merge(callback_params)

    expect { Fintecture::Connect.verify_url_parameters callback_params_test }.to raise_error('invalid post payment parameter s')
  end

  it 'verify_url_parameters Error no session_id' do
    callback_params_test = {app_id: Fintecture.app_id, app_secret: Fintecture.app_secret, s: 's'}.merge(callback_params)
    callback_params_test.delete(:session_id)

    expect { Fintecture::Connect.verify_url_parameters callback_params_test }.to raise_error('invalid post payment parameter session_id')
  end

  it 'verify_url_parameters Error no status' do
    callback_params_test = {app_id: Fintecture.app_id, app_secret: Fintecture.app_secret, s: 's'}.merge(callback_params)
    callback_params_test.delete(:status)

    expect { Fintecture::Connect.verify_url_parameters callback_params_test }.to raise_error('invalid post payment parameter status')
  end

  it 'verify_url_parameters Error no customer_id' do
    callback_params_test = {app_id: Fintecture.app_id, app_secret: Fintecture.app_secret, s: 's'}.merge(callback_params)
    callback_params_test.delete(:customer_id)

    expect { Fintecture::Connect.verify_url_parameters callback_params_test }.to raise_error('invalid post payment parameter customer_id')
  end

  it 'verify_url_parameters Error no provider' do
    callback_params_test = {app_id: Fintecture.app_id, app_secret: Fintecture.app_secret, s: 's'}.merge(callback_params)
    callback_params_test.delete(:provider)

    expect { Fintecture::Connect.verify_url_parameters callback_params_test }.to raise_error('invalid post payment parameter provider')
  end
end
