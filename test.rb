require('openssl')
require('base64')
require('json')
require ('uri')

private_key_file = %q(-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC5GnIf2z104zO/
+i0n3cBuRHpkUHM36xI9Uf1JV/UTEYzzAo1u/+XXxsnLDcaSjm+zca+zJFjK4yae
TgL7esn+Cdngy311huDBzkIf0wRCNmtyj8FyYkbNhFLPot3YFZGhy4em+AtwvQQU
0eo9BLhJJd33apJhHJfj27dOjSxcIrMtno6YyihskbX0DB1xLVZdoL22NbZmnZqH
C5ZXV5qOFWhNOiT1YKh2Yd88XQnYAFwmWWS95SuEY65n+QR2a6wh7RwjHvgDOErf
ms96Hp0cjhWFuZJ39WDMHvGyjJ+buRKLMlSWyx/Ft84QiT59mIKipzR59eAJ351X
B91hOwCvAgMBAAECggEAGjMADDo/zJeL75Q9Z/MfFXxjxmcMp9GB12QPcZ4ddgF5
7btiwV8+7PeaAD+G5595d/CTacuvNahJAwcPrQCILoi+ae7jZwscLNJA0bhQVf7V
3nUycDoww04DWpg2xirnXfsszBk3pVFbjobXnKNaYiAV9rsC1PPzG7ExlNCugqu4
PSoKVU7HTM+8YDPEpHeT9z3uIV7zFzgNq1+/dIg0GBZZM4U9Qe+OztroRnfb1BT6
WIqAxCExfBa2GHSAlJFS0+NmVwcoKWRCsmUH6ISj4SiiJvVJfIca0/GqycBqKzvQ
TOQh3c+IrXyG2ssiK9Nb6lqBGviHhB3p6C6tF4wPQQKBgQD/pG3JiC7cAOq5Afae
MFZ9STfIRfd/pocrZByEduoc9pkAprhv4KU1M+ARJ+M1Svg74lAv9ULd1aoSONf3
+NQbdbNJBFXSoS/YylKDJNYM0Yrfu+ku+1/m6kPNIg82EtMYB+Li1eAYAa4x/gJw
RsNEiZHWpF0Zgy+hSn+vtrocSQKBgQC5XL/2baMCW8hLNy+GwONrtqJvcPxoQbZC
AHPLN8Hsau4vE/LWjXqhHc82ze5zoMUNA/wk0Ic2dvixu87HInc8oXTSuNorN/Y6
e4Nnqu7Nu2C7Q5eieHupfNVTt8/EZb0lb6YGus7PxMbsWK5o5xZhmNnhRWERr35A
i3eVmCWFNwKBgQCxM9U2QUPaFHifzZCZjoAlUD9uf7FTtqczmK171MHrWbQtE2P9
iQZ7nn3O5otEQbdYK0PSOnwjMRw2jViG9uBwOGISVwL2geycpYIUjdAiCo3tEGBO
xMhxVCmzY8yPevUAT1ciTYaMnX2WAbDHCwYH2CRTWJOAP8MgVnez4UGYoQKBgAbj
FlLOogbdaCS7SS3Fju2anJBtb0NkZaQwJh0/1hm1o2HmaNhl609/LwrHPfvX1lp0
cnLfuJZidz0LUFR/yFRdX1zQ93IxoxlrK2e3pyXHt4Fdso2b0mRqufZhVvviF9QD
QPTxDewUUJvJc7l8FI3NwxKmpEOm9JbrV6ccPxCjAoGAJ8uwnsH27gzzFxsf1Frc
OYFOw3vyqw1pd6I4uIq7vWtqT4GAmwL2lzEanTMsuFY/rRkSRrTR8hLZPmFZM5zs
qZfkZDAuZEuZEj4gE1YExhRYshyWWXN8NdkW1DITGSksUttGK+eM4ZsfMbnt8ibV
RySRy3s2FItWMAOF1KvDZkA=
-----END PRIVATE KEY-----)



signing_string = "(request-target): post /pis/v2/connect?state=somestate&redirect_uri=http://www.google.fr\ndate: Thu, 16 Sep 2021 12:38:56 GMT\ndigest: SHA-256=ufw4Q5lZQzGRgad86Mds9om1KH8ie5OgKOMQ/PfbESo=\nx-request-id: f9d0fb3b-9306-456a-acba-38d31badd87c"




# ------------------------ Encrypt ----------------------------
puts"
--- Encrypt ---

#{signing_string}
"



digest = OpenSSL::Digest::SHA256.new

# private_key = OpenSSL::PKey::RSA.new(private_key_file)
private_key = OpenSSL::PKey::RSA.new(File.read("key.pem"))
puts File.read("key.pem")
signature = private_key.sign(digest, signing_string)

puts "
Result : #{Base64.strict_encode64(signature)}
"




# ------------------------ Verify ----------------------------
puts'
--- Verify ---

'

public_key = OpenSSL::PKey::RSA.new(private_key_file)
puts public_key.verify(OpenSSL::Digest::SHA256.new, signature, signing_string) #=> true/false