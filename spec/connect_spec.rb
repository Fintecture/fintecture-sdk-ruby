require 'json'
require 'fintecture/pis'
require 'fintecture/connect'
require 'fintecture/exceptions'

RSpec.describe Fintecture::Connect do

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


  payment_attrs = {
      amount: 125,
      currency: 'EUR',
      customer_full_name: 'Test bot',
      customer_email: 'email@test.com',
      customer_phone: '666777888',
      customer_address: '123 Test St.',
      customer_ip: '192.168.0.1',
      end_to_end_id: '5f78e902907e4209aa8df63659b05d24',
      redirect_uri: 'http://example.com/callback',
      origin_uri: '',
      state: 'bob',
      communication: '1',
      psu_type: 'retail',
      country: 'fr',
      execution_date: '2020-02-20',
      provider: 'Test provider',
      beneficiary: {
        name: 'Ben Efitiary',
        street: 'Test St.',
        number: '123',
        city: 'TestCity',
        country: 'FR',
        iban: 'test iban',
        swift_bic: 'test swift_bic',
        complement: 'test compliment',
        zip: '18006',
        bank_name: 'Test bank'
      }
  }

  callback_params = {
      session_id: 'session_id',
      status: 'status',
      customer_id: 'customer_id',
      provider: 'provider',
      state: 'state',
  }

  before(:each) do
    access_token_response = Fintecture::Pis.get_access_token

    @access_token = access_token_response['access_token']
  end
  
  it "generate a correct URL" do
    test_payment_attrs = payment_attrs.clone
    test_payment_attrs.delete(:country)

    mock_url = "#{Fintecture::Api::BaseUrl::FINTECTURE_CONNECT_URL[Fintecture.environment.to_sym]}/pis/retail/all?config="
    url_response = Fintecture::Connect.get_pis_connect(@access_token, test_payment_attrs)

    expect(url_response[:url]).to include mock_url
  end

  it "generate a correct URL with float 0 amount" do
    test_payment_attrs = {
        :amount=>42.0,
        :currency=>"EUR",
        :communication=>"201910-165-1",
        :customer_id=>43,
        :customer_full_name=>"M Foo Bar",
        :customer_email=>"foo@bar.com",
        :customer_ip=>"127.0.0.1",
        :redirect_uri=> "https://awesome_payment.com/46584654asdazf4a6546fe46aef4/fintecture",
        :origin_uri=>"https://awesome_payment.com",
        :state=>"201910-165-1"
    }

    mock_url = "#{Fintecture::Api::BaseUrl::FINTECTURE_CONNECT_URL[Fintecture.environment.to_sym]}/pis/retail/all?config="
    url_response = Fintecture::Connect.get_pis_connect(@access_token, test_payment_attrs)

    expect(url_response[:url]).to include mock_url
  end

  it "generate a correct URL with float number amount" do
    test_payment_attrs = {
        :amount=>42.2,
        :currency=>"EUR",
        :communication=>"201910-165-1",
        :customer_id=>43,
        :customer_full_name=>"M Foo Bar",
        :customer_email=>"foo@bar.com",
        :customer_ip=>"127.0.0.1",
        :redirect_uri=> "https://awesome_payment.com/46584654asdazf4a6546fe46aef4/fintecture",
        :origin_uri=>"https://awesome_payment.com",
        :state=>"201910-165-1"
    }

    mock_url = "#{Fintecture::Api::BaseUrl::FINTECTURE_CONNECT_URL[Fintecture.environment.to_sym]}/pis/retail/all?config="
    url_response = Fintecture::Connect.get_pis_connect(@access_token, test_payment_attrs)

    expect(url_response[:url]).to include mock_url
  end

  it "generate a correct URL with a country" do
    test_payment_attrs = payment_attrs.clone
    test_payment_attrs.delete(:psu_type)

    mock_url = "#{Fintecture::Api::BaseUrl::FINTECTURE_CONNECT_URL[Fintecture.environment.to_sym]}/pis/retail/fr?config="
    url_response = Fintecture::Connect.get_pis_connect(@access_token, test_payment_attrs)

    expect(url_response[:url]).to include mock_url
  end

  it "generate a correct retail URL without a country" do
    test_payment_attrs = payment_attrs.clone
    test_payment_attrs.delete(:country)

    mock_url = "#{Fintecture::Api::BaseUrl::FINTECTURE_CONNECT_URL[Fintecture.environment.to_sym]}/pis/retail/all?config="
    url_response = Fintecture::Connect.get_pis_connect(@access_token, test_payment_attrs)

    expect(url_response[:url]).to include mock_url
  end

  it "generate a correct corporate URL without a country" do
    test_payment_attrs = payment_attrs.clone
    test_payment_attrs[:psu_type] = 'corporate'
    test_payment_attrs.delete(:country)

    mock_url = "#{Fintecture::Api::BaseUrl::FINTECTURE_CONNECT_URL[Fintecture.environment.to_sym]}/pis/corporate/all?config="
    url_response = Fintecture::Connect.get_pis_connect(@access_token, test_payment_attrs)

    expect(url_response[:url]).to include mock_url
  end

  it "get_pis_connect Error no psu type allowed" do
    test_payment_attrs = payment_attrs.clone
    test_payment_attrs[:psu_type] = 'other'

    expect { Fintecture::Connect.get_pis_connect(@access_token, test_payment_attrs) }.to raise_error(Fintecture::ValidationException, 'other PSU type not allowed')
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
