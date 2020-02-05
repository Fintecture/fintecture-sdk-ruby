require 'json'
require 'fintecture/pis'
require 'fintecture/connect'
require 'fintecture/exceptions'

RSpec.describe Fintecture::Connect do

#   Fintecture.app_id = 'a229d811-0f17-4295-b135-99bb1cb2ca63'
#   Fintecture.app_secret = 'a50afa3e-fea5-4bb8-86bd-b52c945fc0e8'
#   Fintecture.private_key = %q(-----BEGIN PRIVATE KEY-----
# MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDI8ft2cX5Zos3X
# PLT5/XlM6GYxAc122+fufVEKlMWIxZiSVfElhvznTa5jQPyTw5dshBZCZ6EZK/RT
# oGZTrUC7EE6/ZI5gvVz6foVQHbpMIyGQ0dL2ne/2+gSxmOO3XtdIYQp7k0uINtUr
# 2Pbzi8n//FRj9TJqpQoHN1PB+UPBzjklis8o4pZctZ9HVpzb6vK8qga1L+ja+E7K
# d9EdueV5Y29Uh7bPoGDGrFjZrQpcbvHEIvlvdMIabrpBu/4uzZ4f663as/vHDMDr
# 9zP4VOpZcME4D2UBiRiztbDQukgUQnYMudHfN6zuYIAig9eSI2sPQlgciUWJ+ryD
# WkmwRozPAgMBAAECggEAV3+O6KdIxk0u5m8nusdVn1h+zw4i4oOk/WMR+9KGJSUt
# Z2MGyzl5PFrF+bAdi1YaxITLkITBUE2kaRmqFPuW+R2DvLFTkepC50xaTmVzbp3J
# it7ixsJE8D0z+AVD+t/QTFL9Fowv0pNVxW8HMUuIXPAJ6zCkkG1m7Xd5ADjC+UtF
# QAaVHcAmz2lKRBCP9lzzCN2TfVpMGu71KcpaPXXhzuHWXsi2jEWyjvPajfLQvlQI
# UVsLRJsNlz1PILslU/tuu2vASmpl7aWy+PxXGYTd7UOqeQ+es4xYpxmMfR2hhV4Y
# OVOMRtqzmgh8QCEsuVfuA5sXxrksc/0J7iGXm2+SYQKBgQD9CoJmPt8KicQDkbsY
# i6fjbhWOsVm1iWZJjXQR1XwsDmOmlK8gBfwHm2wFhaRt5G1jeo0/Trme4bKpvSOn
# ddGJjJln3vk7TwcCquo/G7D+ZzB3IqL2FEqZqPFTTTu/eVHVtPXUurt4SpkZnzH+
# 1vt3YKKDq31e4auBIW+ZBbl2UQKBgQDLS4WGQTCVZleeQ02PbdSd2IcQL/4ye3ao
# m6btC0GmrhhTd+rXdVdRRxxkkmnQDLVOnj05dCXOxtnhVMTsU+B4hUTNQvp8gW1c
# BID5p08kvUOjSrfjkE5dIyp08H9cuFTuwL55sIvvs5NimJ8fWoaOCb1pgtzrVrl7
# o40uRCppHwKBgQCPUWd//7YWYucZWm4MvfTONKiTFFIKJxM/L5YBD9hvn4rDa80w
# pxMTP+1Tx1jVQR7PzDa6F528pnqp9s196JZQgMjWcwzYka8XzLQ2IDoELW/e2khQ
# dje2hmCA3OqtTUqTbxYZcdYCkMXcJDWN8Denap1BVF0C43BfCBAMLJjZsQKBgFRl
# UtZMY+Xx6bfrCtzbZKPuywteUTIV7UnL7H2F6chPiAvGwbiWnxw/4DqkScc0L2Sm
# 7pXWcQepp7QS4/mUTKDb+pcYEjLz7DmCKST7XzDKXbUBhNu1AcNKoQqQ+N6+K4w+
# ehS8xStKqooJAC4c/7Uht/+Ac0RD6Za5bBfj9pNTAoGAGHiUKyN/wB5joM6/K7bm
# StLwtZclgd2jkqPp5yuhmSpXPkQmEePhWrHuEx2pF6hdSvI1RRydNgTn0YmpB0bM
# WDQPSNRwcsKTJVM2qb6Xx2ziBhGZf1vdyYLlin+vigoWgGg5xUAsUG0cGbloZ/dB
# WosgDj9AGW6w4ETDnTGCA1Q=
# -----END PRIVATE KEY-----)
#   public_key_str = %q(-----BEGIN PUBLIC KEY-----
# MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyPH7dnF+WaLN1zy0+f15
# TOhmMQHNdtvn7n1RCpTFiMWYklXxJYb8502uY0D8k8OXbIQWQmehGSv0U6BmU61A
# uxBOv2SOYL1c+n6FUB26TCMhkNHS9p3v9voEsZjjt17XSGEKe5NLiDbVK9j284vJ
# //xUY/UyaqUKBzdTwflDwc45JYrPKOKWXLWfR1ac2+ryvKoGtS/o2vhOynfRHbnl
# eWNvVIe2z6BgxqxY2a0KXG7xxCL5b3TCGm66Qbv+Ls2eH+ut2rP7xwzA6/cz+FTq
# WXDBOA9lAYkYs7Ww0LpIFEJ2DLnR3zes7mCAIoPXkiNrD0JYHIlFifq8g1pJsEaM
# zwIDAQAB
# -----END PUBLIC KEY-----)
#   Fintecture.environment = 'sandbox'

#   Fintecture.app_id = 'e43c1b68-9208-4a4c-9872-bf7e11a18ac9'
#   Fintecture.app_secret = '3daa61c7-fa01-4645-b2fa-5d7a207a9a2d'
#   Fintecture.private_key = %q(-----BEGIN PRIVATE KEY-----
# MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDQVXYu/0fofTyt
# MDig3W1GEyg+Gmmme4vqxxhKoYMUN90iBOs/wg1+w58Uas+frituB+Ne0EEkjM6U
# FHmjLs/cqFV6U6KUeLKoMGc3hmaSUTP39v9xrIkA8NzRXxfWNnivciEFJmc4d4Fx
# f1dO/2JSIXzu/DkEPBV4aKNU+lQW0Y+QSBqlvBtjPwlitvZkjW6NCvBeUZC3YQt8
# HK9K87ehKeB5snLs5MS/5WbtwNUEJ9IPceayOZkgcMMj1Co9bF2hZ1qyC+IevdCm
# FADqr2fe5nqsLgXXCT9fRdrIo8zvMPmsJ3ixJEJMh5hNFwOjkruzoprC+4nUAXVB
# JyheokQ9AgMBAAECggEAAY4bW1Wm5Cj7KPfKx58F6WRlnbRCXm6RqGdjQQgpNR9t
# oSSUQcRhdJuVNmiagCcJ3/P8uIDcqGv8psWFJ7itVVWHip0EaHaC+7DQzgaAAYH/
# RByUSSiJvt4NZ+qwmakloXminkOfhZ/7ivm+XX9k7OQFgLf7qcWhC2Y/wd465Nvl
# wDGMLhv3gfJxQ3SjNBlklXqykKPzPmOaoVQM2mXYmd3yVG9b0fMqgmV70WSKm1yU
# xM0H/TxcyZ2rY4tTkBN/3dqmUC2B0qP0+3hJBUxL+extSKvKEgFh3nUkl10mIPBU
# 2vd/sdOqCLkKuuPjX3BwreiiebnnwHI2za4sImAvQQKBgQDorVi43OF9rVP2qWRi
# rzsLn7y4LK4lcuUcGifXxq75d+gYXlwP3U8cFn+m+WbllXswOh9l0jGKuaRiyZ1O
# wgAPpLinxo7OPbQfjKKQeRGBuRS3JGBT9n1rLD15wHNjQOV1sBUh4CCcqMyg3F3C
# XnFZl/D+yfm0OdjnUqa9JspO+QKBgQDlN3MPEqrhyP4dqXdILSkAghclEs7PJUUv
# /mHNp0cmjadoqneJGb5yDGj8niHWXU6UIdRJrxNY7mih3OAJotj47BXOiTObBf5g
# ZFhF9dit7y9TmNMq+OeTz+mwGX1KPJoeaZIZADzdU2p0cNGboVRlRlXvTZVCrxvC
# hsuphLT8ZQKBgQDBOPMs0YEQdRf9Br6ulQZbqNN3vuL/hmJs6+uabQxxbvn3AqVB
# J2/Cy4xGhWbF0VTzv9DDJcKuiWvR/cv8025pj0kpSuLcsrEaYhe+EkxPhfuF+1dj
# YpbUoXCL4x3vlrz29rsV3qI2dpc4Hshd2UAYPu2LKP+Mg110/FYrTkNDQQKBgDkk
# c6ikTLlw8/jNEJGLwJcB12dEow39CpyGXDd6pkA0PDHZnWcuZc3kzh98BI9+P2Kq
# dFPSM46OEMOZXrjIQjL8GAufJKBXBC1flqoKOfRSlofOp4Yk+wZcZLOkBxoEtZ8z
# TlqxNnsumnFg1sBnnbSJrk60FqvDH7aFCCzAiqYJAoGAeRu9A4V8O//egfeTQRu/
# UhwPoJsXuNF1aVebrgF94kpbyOcsAD7W/3YK5sI1iGvTyk3smK3ggIHaZElW0sL2
# TtZ91owkYd2ZINnB2mHM+M/1ODEgOx3Cs5Yy3p2geL8vv93BC44+qEdPO9gInpmc
# hvzFkX0Jk4G+Pz1MaLR2Ops=
# -----END PRIVATE KEY-----)
#   public_key_str = %q(-----BEGIN PUBLIC KEY-----
# MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0FV2Lv9H6H08rTA4oN1t
# RhMoPhpppnuL6scYSqGDFDfdIgTrP8INfsOfFGrPn64rbgfjXtBBJIzOlBR5oy7P
# 3KhVelOilHiyqDBnN4ZmklEz9/b/cayJAPDc0V8X1jZ4r3IhBSZnOHeBcX9XTv9i
# UiF87vw5BDwVeGijVPpUFtGPkEgapbwbYz8JYrb2ZI1ujQrwXlGQt2ELfByvSvO3
# oSngebJy7OTEv+Vm7cDVBCfSD3HmsjmZIHDDI9QqPWxdoWdasgviHr3QphQA6q9n
# 3uZ6rC4F1wk/X0XayKPM7zD5rCd4sSRCTIeYTRcDo5K7s6KawvuJ1AF1QScoXqJE
# PQIDAQAB
# -----END PUBLIC KEY-----)
#   Fintecture.environment = 'local'

  Fintecture.app_id = '924f6171-596e-45b5-9cf9-dc88e58fcf3d'
  Fintecture.app_secret = '37d4b80f-123f-4c28-b497-cd23c20707e1'
  Fintecture.private_key = %q(-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDAYViR+A2u1rPH
mbqfdV8a9kBLiPyWzSUn0yEtPkuDqgFmwwKn8YhQ+QYJzE/pcKYLYJTsMKOmd4LJ
PxVb4RqFKFbdY/6PkwHVODjp05ll+r8UqyEACF8x4/r6smhiQFfjdnc4GZ5WL08B
ChX4r+agTeM5Io58witGM+xfuBZsWaBxlrxc3yzo/Kz7zpkTKJPha/vSSIxXiG17
dhCMXDp84W6w9fn4xuhmCKzpfmEew4uS+PTTAKs4okXr4KoOsxuaOXsmVjgeYO9v
7KrDQPEfCPfsz6tsYkSOTFpLKbOuY+EfEA1V0xFLftuF6mW0hNpDYKlDiHEnWD32
RSYm0X1NAgMBAAECggEAJRcPj7LylmUUC7VGjwQ+xhC4hCegxUU/dt5kfNfQEM4n
z4NlAXKWfMAKKzzuIjxi8voXtDLLdmZ/u2OTb1+msIn+t1fWRiGKXqykgmZWopv1
l5tHtT0n91M0Of3IFLtBhpv6L8F2rriXw4RJiKUHMpxZpNQWAxUfaT1NAwZXomNO
sS0/A0zaGkf7W6NHFmOHCc5Z1+aFbZGx4aSosB8XpXqA7qjIo9fD1D3fbJb0cLG9
yj51A+8vWh2QMDzL4TaLDcFd9SeRpbJi728bEILp36FJXPeUHOgRQEUJV+BkH4KO
vr6n/Iin9QtfMW294ZZZOo66QCe+oUHKg8F9HeM80QKBgQDgMtTFHdFBTZUT1BV0
psNZQABC1CqwH3qIufBSZyKC8aSXj8G1V7CbfR+GD+S4P7CrAsa6m8QyJpcTpCig
15bRb8TrUvRaWX82n/IqeaGjkiprBVE7V9lx1k2Sr8C8t2pPHss0xr8x5PzXyvs7
Bc8zuHM3E+/czVavPgDgVnKXcQKBgQDbqx5fElyhX7mPd9TihZj2GhIm2gPB+COf
z9IWuuBCnMkXowAe86bWW9njEDICjX1y/5Mnn6axw6GUuJ9UpqmweL6cU4AzYCeS
xsToBTjq2/BYNgK6nBsWac2VkdzJE3pnR7cq8gxzy+LZ6TN4O+rf0RYfma0tzoMh
OsbDzEftnQKBgQChNywUykosoTMv3PPIvBoA1araY2KG3zvnkX0kZBFHA6gNbEwo
sHPIe4LtjgQ0EWhisE5i5ZuBTIqajxLABgbnd22soiwfw/dcOkuTC3+V9YcXCe3N
tHAiEa4aatM3YNTLLCOHQds+b6D5M3bQjG7gjCQdWPLEXcuVnApZRxCDoQKBgGls
xcXBDT3RsD/ftgcFMTUjrASDa3xDN+2yEtUf2RN/Ja+3Zg50x2RnbrngAvBgsY1o
hVpl792u0zSKKsW4uwXb3Tcvh/6gLj3uMYBdSUTGS6I6QbMHyqRGIQmgmILUW1GI
BKuSwVEtz/DfT/lrYD0Mnv6JhajPTPW8vLopp3etAoGAcoyl/1mrixQcdFlPk3Xx
1z+8gXIjW7XRJ80ToKlHBK53+GTv43Xk7OXwTZDbhmslan+oVScMmuS6azBgaNId
rRg9gtRkqgLTCH385PbP0pT4PLAhI+hIN60ZVtulb+kI6salX0rk8MxCAyd6NbgK
O+ebxgspujahx79k7YUEF2E=
-----END PRIVATE KEY-----)
  public_key_str = %q(-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwGFYkfgNrtazx5m6n3Vf
GvZAS4j8ls0lJ9MhLT5Lg6oBZsMCp/GIUPkGCcxP6XCmC2CU7DCjpneCyT8VW+Ea
hShW3WP+j5MB1Tg46dOZZfq/FKshAAhfMeP6+rJoYkBX43Z3OBmeVi9PAQoV+K/m
oE3jOSKOfMIrRjPsX7gWbFmgcZa8XN8s6Pys+86ZEyiT4Wv70kiMV4hte3YQjFw6
fOFusPX5+MboZgis6X5hHsOLkvj00wCrOKJF6+CqDrMbmjl7JlY4HmDvb+yqw0Dx
Hwj37M+rbGJEjkxaSymzrmPhHxANVdMRS37bhepltITaQ2CpQ4hxJ1g99kUmJtF9
TQIDAQAB
-----END PUBLIC KEY-----)
  Fintecture.environment = 'test'


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
      communication: '1',
      psu_type: 'retail',
      country: 'fr'
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
