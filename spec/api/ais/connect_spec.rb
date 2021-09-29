# frozen_string_literal: true

require 'fintecture/api/ais/connect'

RSpec.describe Fintecture::Ais::Connect do
  ais_client = Fintecture::AisClient.new({
    environment: 'test',
    app_id: 'bad4a71a-da21-4d38-9743-5f3a2fc566ca',
    app_secret: '16f78b06-575c-4e5a-8258-8cf823890dbf',
    private_key: '-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDOoTlyF0HaP8BG
FkuQwjglYT+Kcs6Lc+pGHXYPOv1uhpo4gVPg0DVUjLxLWjWwPSbEzHiCryz1XGb4
IK8CNWXOdxMMfd1HJhzCsbbD4FDRzOeK4vjaNTBqKbV9JOkeoFe3/pPPab11/zvA
5cNK0vY4WzqluVrf7hE2Ju89hCl0ORFbMtKUlarptOhADtL6ZlswWO5K+WexQnp+
MiLFe/1JX3gOA0pGvtijRKdK8H/dlxLxCuxOw2nMpIAMrr1w3EqsfSSry3Pf0NE+
YX3rh+SsjWsFYezlx8YBOb4r1xaXDk87GKv0x9DrIOVVRXyvOcIpDEvPWGYqFCQ9
T/AV8IR/AgMBAAECggEATARvXGRnAzKJ+57vLPHu8v2MgVRMXWyHJ0VmbiL/Ip7d
dOVLZP1kaVcfXL9y2gQdU7B/s2Bb82aLsURg7jiT3DndZa6Wbjr8wLndqcFIKm8u
Td/Duo9v4Na4YLJoGy7VJqk/WsKlg5gjNQuyZcAn+kLB2D9RSenNJjV7tY9+KrW8
OLQnoo0l/escoRu4BB/aZ0MYp40afTYRdgmlzqmpchE7r6Do0dx5FAgu6kThNUWL
ZUvhiuAHAc5rcB+4qkgUVUX0UG5ZHXtA4F7dtbb0yv9slOCC0dnpZFwYUOYLzP19
xBMitAxVtMKmUDOSy2zjG4/fA3KD/TBW+5BAmEQQzQKBgQD5055etJxbiIbEdvmj
0yJsKzefT7cWPBwMsVK/rh6lvhc2LDM9Als0fmrEAAyzezEDTUSPOYid+t6hUzpS
cfAGhjuxxVljyW9NwiqiwcRyb0PB/CvaWONvo45p0Sx2dRL1lPcA7Whelf1k/vk2
qXDRzXaswXTZU8QlHKU5Uzk4WwKBgQDTvFik9snZH5UdpsBz9qyqy1UMwxqrxOTz
2UB021kSjXe1+RoO7QtUFJ0fdBFZUWAtVCjosCco6vr2LbvTI+hIh+TKtd9vpNoI
QQHIQzvXV6eZqzoZjeM28I+i77nGZL5LlGafT2SRJlDYAR+RQUDQM8zDkhtByzf+
R3pHexN9rQKBgQCaRnN7On+ACvxmYK5i26RbNgkASYLfqTkNIYffNNBaO9wrqPnv
SAA4l4SpCvrM71tiFZor9DSIkn5fE31lolS+QrCkZCGCfMdONoSLw6rjnBA0v9v4
14GD1HXCpNiXQk719wrduL4GAwvbDZWqitJPzVjm8ASPnKn43QqvLtScFwKBgGd1
lb7tk82TIBLAAzPmqZI/DozQ3Lxn1hPM6TDwaUKme4Mgd/opG6r285uF5GBHYf5k
LCUexdO5le0qhady2TJvrHzch5QO8jasRQmsyJW9j/iHcTlBWm/i9dyA1L67RTy7
A7X+Xj6KgWA6lEkuoFPbq8c4Ijdw7ChEltxMqEZ1AoGBAKUBDTFuiNW8CDqbYV/c
wpTvQe7zJYmXP01BfXRPvy/iZ773C9OZHMtqAo7Y6jZLZ5PStW/iTFzWfQAPO3oh
XGsIpsBmopOdzpSIiCYzC8m/hvwwAWeW7/fDW2YVV3BeKNM4UKYP+DLQlWdeMOcC
WDBn/gcnh2/UuAC53+VumS4n
-----END PRIVATE KEY-----'
  })


  it '/connect' do
    connect_response = ais_client.connect "ok", "https://www.google.fr"

    connect_id = connect_response['meta']['connect_id']
    url = connect_response['meta']['url']


    expect(connect_id).not_to be_empty
    expect(url).not_to be_empty
  end

  
  it '/connect + optional scope' do
    connect_response = ais_client.connect "ok", "https://www.google.fr", "accounts"

    connect_id = connect_response['meta']['connect_id']
    url = connect_response['meta']['url']

    expect(connect_id).not_to be_empty
    expect(url).not_to be_empty
  end

end
