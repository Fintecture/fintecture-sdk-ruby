require 'securerandom'
require 'openssl'
require 'base64'
require 'json'


module Fintecture
  module Utils
    class Crypto
      class << self

        def generate_uuid
          SecureRandom.uuid.gsub!('-','')
        end

        def sign_payload(payload)
          payload = payload.to_json.to_s if payload.is_a? Hash

          digest = OpenSSL::Digest::SHA256.new
          private_key = OpenSSL::PKey::RSA.new(Fintecture.app_private_key)

          begin
            signature = private_key.sign(digest, payload)
            Base64.strict_encode64(signature)
          rescue
            raise 'error during signature'
          end
        end

        def decrypt_private(digest)
          encrypted_string = Base64.decode64(digest)
          private_key = OpenSSL::PKey::RSA.new(Fintecture.app_private_key)

          begin
            private_key.private_decrypt(encrypted_string, OpenSSL::PKey::RSA::PKCS1_OAEP_PADDING)
          rescue
            raise 'error during decryption'
          end
        end

        def hash_base64(plain_text)
          digest = Digest::SHA256.digest plain_text
          Base64.strict_encode64(digest)
        end

      end
    end
  end
end