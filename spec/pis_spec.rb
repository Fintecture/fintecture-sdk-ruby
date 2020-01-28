require 'json'
require 'fintecture/pis'

RSpec.describe Fintecture::Connect do

  Fintecture.app_id = 'a229d811-0f17-4295-b135-99bb1cb2ca63'
  Fintecture.app_secret = 'a50afa3e-fea5-4bb8-86bd-b52c945fc0e8'
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

  it "get access token" do
    access_token_response = Fintecture::Pis.get_access_token
    access_token_response_body = JSON.parse access_token_response.body

    access_token = access_token_response_body['access_token']
    token_type = access_token_response_body['token_type']
    expires_in = access_token_response_body['expires_in']

    expect(access_token).not_to be_empty
    expect(token_type).not_to be_empty
    expect(token_type).to eq 'Bearer'
    expect(!!expires_in).to be_truthy
  end

  it 'prepare payload' do
    access_token_response = Fintecture::Pis.get_access_token
    access_token_response_body = JSON.parse access_token_response.body

    access_token = access_token_response_body['access_token']

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

    prepare_response = Fintecture::Pis.prepare_payload payload_attr, access_token
    access_token_response_body = JSON.parse prepare_response.body

    meta = access_token_response_body['meta']

    expect(meta['session_id']).not_to be_empty
    expect(meta['status']).to eq('provider_required')
    expect(meta['title']).to eq('Payment Prepared')
    expect(meta['code']).to eq(201)

  end
end
