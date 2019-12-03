require "base64"
require  'fintecture/version'

module Fintecture
  class Connect

    SIGNATURE_TYPE = 'rsa-sha256'.freeze

    def connect_url(payment_params: {}, config: {}, type: 'pis')
      @payment_params = payment_params
      @type = type
      @config = config

      validate_payment_integrity

      payment_params.end_to_end_id ||= Fintecture::Utils.generate_uuid
      payload = build_payload
      state = build_state payload

      "#{BaseUrls.FINTECTURECONNECTURL}/#{type}?state=#{Base64.encode64(state.to_s)}"
    end

    def verifyUrlParameters(parameters: {})
        @post_payment_params = parameters

        validate_post_payment_integrity

        decrypted =  Fintecture::Utils.decrypt_private parameters.s

        test_string = Base64.encode64({
            app_id: this.config.app_id,
            app_secret: this.config.app_secret,
            session_id: parameters.session_id,
            status: parameters.status,
            customer_id: parameters.customer_id,
            provider: parameters.provider,
            state: parameters.state
        }.to_s)

        local_digest = Fintecture::Utils.hash_base64 test_string

        decrypted === local_digest
    end

    private

    def raise_if_klass_mismatch(target, klass)
      return if target.is_a(klass)

      raise "invalid parameter format, the parameter should be a #{klass} instead a #{target.class.name}"
    end

    def validate_payment_integrity
      raise_if_klass_mismatch @payment_params, Hash

      error_msg = 'invalid payment payload'

      raise error_msg unless %w[pis ais].include? @type

      %w[amount currency order_id customer_id customer_full_name customer_email customer_ip].each do |param|
        raise error_msg if @post_payment_params.send(param).nil?
      end
    end

    def validate_post_payment_integrity
      raise_if_klass_mismatch @post_payment_params, Hash

      %w[s state status session_id customer_id provider].each do |param|
        raise 'invalid post payment parameter' if @post_payment_params.send(param).nil?
      end
    end

    def build_payload
      attributes = {
          amount: @payment_params.amount,
          currency: @payment_params.currency,
          communication: @payment_params.order_id.to_s,
          end_to_end_id: @payment_params.end_to_end_id
      }

      meta = {
          psu_local_id: @payment_params.customer_id,
          psu_name: @payment_params.customer_full_name,
          psu_email: @payment_params.customer_email,
          psu_ip: @payment_params.customer_ip
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
      Fintecture::Utils.sign_payload payload
    end

    def build_state(payload)
      {
          app_id: Fintecture.app_id,
          app_secret: Fintecture.app_secret,
          signature_type: SIGNATURE_TYPE,
          signature: build_signature(payload),
          redirect_uri: @config.redirect_uri,
          origin_uri: @config.origin_uri,
          order_id: @payment_params.order_id,
          payload: payload,
          version: VERSION,
      }
    end

  end
end