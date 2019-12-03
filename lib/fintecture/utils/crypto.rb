require 'securerandom'
require 'openssl'
require 'base64'

module Fintecture
  module Utils

    class << self

      def generate_uuid
        SecureRandom.uuid.remove '-'
      end

      def sign_payload(payload)
        payload = payload.to_s if payload.is_a? Hash
        rsa_oaep_md = OpenSSL::Digest::SHA256

        begin
          Base64.encode64(OpenSSL::HMAC.digest(rsa_oaep_md.new, Fintecture.app_private_key, payload))
        rescue
          raise 'error during signature'
        end
      end

      def decrypt_private(digest)
        digest_bytes = Base64.encode64(digest)
        rsa_padding = :rsa_pkcs1_oaep_padding

        begin
          Fintecture.app_private_key.private_decrypt(digest_bytes, rsa_padding)
        rescue
          raise 'an error occurred while decrypting'
        end
      end

      def hash_base64(plain_text)
        Digest::SHA2.new(256).hexdigest plain_text
      end

    end

  end
end