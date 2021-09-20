require 'securerandom'
require 'openssl'
require 'base64'
require 'json'
require 'fintecture/exceptions'
require 'fintecture/utils/constants'
require 'uri'

module Fintecture
  module Utils
    class Crypto
      class << self

        def generate_uuid
          SecureRandom.uuid
        end

        def generate_uuid_only_chars
          generate_uuid.gsub!('-','')
        end

        def sign_payload(payload)
          payload = payload.to_json.to_s if payload.is_a? Hash

          digest = OpenSSL::Digest::SHA256.new

          private_key = OpenSSL::PKey::RSA.new(Fintecture.private_key)

          
          puts "
          private_key: #{private_key}
          "
          begin
            signature = private_key.sign(digest, payload)
            puts "
            signature: #{Base64.strict_encode64(signature)}
            "

            Base64.strict_encode64(signature)
          rescue
            raise Fintecture::CryptoException.new('error during signature')
          end
        end

        def decrypt_private(digest)
          digest = URI.unescape digest
          encrypted_string = Base64.decode64(digest)
          private_key = OpenSSL::PKey::RSA.new(Fintecture.private_key)

          begin
            private_key.private_decrypt(encrypted_string, OpenSSL::PKey::RSA::PKCS1_OAEP_PADDING)
          rescue OpenSSL::PKey::RSAError => e
            raise Fintecture::CryptoException.new("error while decrypt, #{e.message}")
          rescue
            raise Fintecture::CryptoException.new('error during decryption')
          end
        end

        def hash_base64(plain_text)
          digest = Digest::SHA256.digest plain_text
          Base64.strict_encode64(digest)
        end

        def create_signature_header(headers)
          signing = []
          header = []



          Fintecture::Utils::Constants::SIGNEDHEADERPARAMETERLIST.each do |param|
            next unless headers[param]

            param_low = param.downcase
            signing << "#{param_low}: #{headers[param]}"
            header << param_low
          end
          

          # Double quote in join needed. If not we will get two slashes \\n
          signature = sign_payload signing.join("\n")

          puts "
          signingString: #{signing.join("\n").to_json}
          "

          'keyId="' + Fintecture.app_id + '",algorithm="rsa-sha256",headers="' + header.join(' ') + '",signature="' + signature + '"'
           
        end

      end
    end
  end
end