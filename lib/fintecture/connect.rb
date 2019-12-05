require 'base64'
require 'json'

module Fintecture
  class Connect
    class << self
      SIGNATURE_TYPE = 'rsa-sha256'.freeze

      def connect_url_pis(payment_attrs = nil)
          connect_url(payment_attrs: payment_attrs, type: 'pis')
      end

      def connect_url(payment_attrs: nil, type: 'pis')
        @payment_attrs = payment_attrs
        @type = type

        validate_payment_integrity

        payment_attrs[:end_to_end_id] ||= Fintecture::Utils::Crypto.generate_uuid
        payload = build_payload
        state = build_state(payload).to_json.to_s

        "#{base_url}/#{type}?state=#{Base64.strict_encode64(state)}"
      end

      def verify_url_parameters(parameters = nil)
          @post_payment_attrs = parameters

          validate_post_payment_integrity

          decrypted =  Fintecture::Utils::Crypto.decrypt_private parameters[:s]
          local_digest = build_local_digest parameters

          decrypted == local_digest
      end

      private

      def raise_if_klass_mismatch(target, klass, param_name = nil)
        return if target.is_a? klass

        raise "invalid #{param_name ? param_name : 'parameter'} format, the parameter should be a #{klass} instead a #{target.class.name}"
      end

      def validate_payment_integrity
        raise_if_klass_mismatch @payment_attrs, Hash, 'payment_attrs'

        error_msg = 'invalid payment payload'

        raise error_msg unless %w[pis ais].include? @type

        %i[amount currency order_id customer_id customer_full_name customer_email customer_ip].each do |param|
          raise error_msg if @payment_attrs[param].nil?
        end
      end

      def validate_post_payment_integrity
        raise_if_klass_mismatch @post_payment_attrs, Hash, 'post_payment_attrs'

        %i[s state status session_id customer_id provider].each do |param|
          raise 'invalid post payment parameter' if @post_payment_attrs[param].nil?
        end
      end

      def build_payload
        attributes = {
            amount: @payment_attrs[:amount],
            currency: @payment_attrs[:currency],
            communication: @payment_attrs[:order_id].to_s,
            end_to_end_id: @payment_attrs[:end_to_end_id]
        }

        meta = {
            psu_local_id: @payment_attrs[:customer_id],
            psu_name: @payment_attrs[:customer_full_name],
            psu_email: @payment_attrs[:customer_email],
            psu_ip: @payment_attrs[:customer_ip]
        }

        data = {
            type: 'SEPA',
            attributes: attributes,
        }

        {
            data: data,
            meta: meta
        }
      end

      def build_signature(payload)
        Fintecture::Utils::Crypto.sign_payload payload
      end

      def build_state(payload)
        {
            app_id: Fintecture.app_id,
            app_secret: Fintecture.app_secret,
            signature_type: SIGNATURE_TYPE,
            signature: build_signature(payload),
            redirect_uri: @payment_attrs[:redirect_uri] || '',
            origin_uri: @payment_attrs[:origin_uri] || '',
            order_id: @payment_attrs[:order_id],
            payload: payload,
            version: Fintecture::VERSION,
        }
      end

      def build_local_digest(parameters)
        test_string = Base64.strict_encode64({
             app_id: Fintecture.app_id,
             app_secret: Fintecture.app_secret,
             session_id: parameters[:session_id],
             status: parameters[:status],
             customer_id: parameters[:customer_id],
             provider: parameters[:provider],
             state: parameters[:state]
         }.to_json.to_s)

        Fintecture::Utils::Crypto.hash_base64 test_string
      end

      def base_url
        Fintecture::Api::BaseUrl::FINTECTURE_CONNECT_URL[Fintecture.environment.to_sym]
      end
    end
  end
end