# frozen_string_literal: true

require './lib/fintecture'



# ------------ Test class -------------
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
# ais_client = Fintecture::AisClient.new({
#     environment: 'local',
#     app_id: '8bd5204a-e467-4d87-86b6-5db5a45a1ea7',
#     app_secret: '9404e1c8-e4c3-422e-9bfb-bb3636af5c2e',
#     private_key: '-----BEGIN PRIVATE KEY-----
# MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDzaeynrY+ZRcob
# peMp08MwSGqmnsovffxe6f7P7DXi6quBWGf277gREIfc9Q7aJvYpnSH5+KslhQ2V
# W5w9oHZCcNGQJSuoxsjaVCUSZBByMQrzxqFtQp4ETjsMbDA85x/XFmfJSFciaU46
# jdoHYeSb+iGmpG8Uh3uWcZtbxKD7WyoJZHvWJ4DHWzYzTKbfkez2hQDZunMYZnSi
# Yjndzwxol/kudmedWvaDTyCIxdXn6KgLrdwz0VgRIQS+0d9bn+IpX+AnH+ITUPm5
# 2zh1bjMCw6o2S3J5yf2XmGm/+9JfUK1hFJmNI8Y8Zf7IyhTzcJm+96RKSx12khtP
# fkrQEh3FAgMBAAECggEAF/X7GwVpf43AZ6jUe/tRuTjDsNusLPEirOgtUmPe6ROv
# JsggUc1Gqf1d1mkUGXLg4/dJDy2EkWivzd5K+sEHKyKmamFSUyagQmeqj40klk0Q
# Fi+dF9+JJQTbaK1ksTYSKw7UUBrMIwHJNtfcWMIw6g69DcWdfqCYkJZl0+p+60cc
# rn5eIw1t5ODlZpETPuvKYfG+VARidpK+e5aBh3B81+kDxupor2Xb/vV9nhpKICng
# AXlFJb277dMEcrKDtrwa21gAm0Y5FpJKSyBq+uiOfW7HMNtnIS6jE8gX8PkL4Tec
# Zp06H3RL+Qw9jIYAKvxL8ocAq518HuBGV8BYyLOwIQKBgQD62XzjgtGQVePQTLQR
# 4hB9c1JMFDhFMX/CAwUe7rK0V4MDEL+Om4OvRJcGXjhlOZBieComAJcssv3iRtMt
# a42nK0nAjqDIOxYKGXqBQ8kSDzfkP9nHRHSNxDE0WPgwhy4hFUzlJzAj024n0zMy
# G7QL3+BVcBGJms6I2u11FpNTpQKBgQD4aVpICqeyWSEyeVyZjcnsSLEInBd28t33
# JoWWHB6f2x6i7M715006YBUfzqwGroX6n1vOcgyEpoKFGa6ANL+eShfpPWml82/t
# Vo96FIvss0AI68uooChbgHXkYOndTDIohqTD1l1e4IWwnabPmO5O9lY/AS/L5TFQ
# hbNyP80HoQKBgBOeyzvoUYfej/EM7tCvQ+bsDDXTJwuScZG1NsNSnDuq1J56wuDe
# nRAqZz2iRPr146swBuvuA+UFIwJ906qrzOqUYjJjdYPzyyeDEqflq2Z0NkTuEZSa
# cBteixKzGsaA7ES+K8OIqyVCNk17IXf73rtHCX7lQxnmN91Qcl5EI8XZAoGAU7Mb
# yl5ctsk1WE5wFwUhXk336JC/j0Kx6469QCDlaLNqFTd5XH29Fcg+FeOLLw0q85Ey
# W9MtyJxaKgLHO0eKsQkCGYKp0FLACdY6rcWyh+S11MuuaXjdYEdecb79zaTY2bLU
# XXAjMc6w/RuBkz1SPqTd1ojN1AO7pAgIuJwqt0ECgYA+o2ypfYiORB+M5iG0fDtK
# MJCzv9oIl2bm0rcBhx2QwdjeTZAQArz9hX4oPkIXmscQoJ+MBxbPXvm8hvFtdvAx
# 6bbbJz6n0+7RXwYkH9RMk/75AQsxBlYqKyV13PK7Fber8mmUKlmPXel47aig6Shf
# SmAi2hLOJo+3ntNJFx1fEQ==
# -----END PRIVATE KEY-----'
#   })

# ######################## AIS ########################

# ------------ Connect ------------
connect_response = ais_client.connect "ok", "https://www.google.fr"
connect_id = connect_response['meta']['connect_id']
url = connect_response['meta']['url']

puts connect_id
puts url

# ------------ Get access token ------------
puts ais_client.generate_token connect_id