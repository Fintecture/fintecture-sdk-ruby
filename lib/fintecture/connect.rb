require 'base64'
require 'json'
require 'faraday'
require 'fintecture/pis'
require 'fintecture/utils/validation'
require 'fintecture/exceptions'
require 'fintecture/utils/date'
require 'fintecture/utils/constants'

module Fintecture
  class Connect
    class << self
      SIGNATURE_TYPE = 'rsa-sha256'.freeze

      def get_pis_connect(access_token = nil, payment_attrs = nil)
        connect_url(access_token, payment_attrs, type: 'pis')
      end

      def connect_url(access_token = nil, payment_attrs = nil, type: nil)
        @access_token = access_token
        @payment_attrs = as_json payment_attrs
        @type = type

        validate_payment_integrity

        @payment_attrs['end_to_end_id'] ||= Fintecture::Utils::Crypto.generate_uuid_only_chars
        @payment_attrs['amount'] = @payment_attrs['amount'].to_s

        payload = build_payload
        config = build_config(payload).to_json.to_s

        {
            url: build_url(config),
            session_id: payload[:meta][:session_id]
        }
      end

      def verify_url_parameters(parameters = nil)
        @post_payment_attrs = as_json parameters

        validate_post_payment_integrity

        decrypted =  Fintecture::Utils::Crypto.decrypt_private @post_payment_attrs['s']
        local_digest = build_local_digest @post_payment_attrs

        decrypted == local_digest
      end

      private

      def build_url(config)
        "#{base_url}/#{@type}/#{@payment_attrs['psu_type']}/#{@payment_attrs['country']}?config=#{Base64.strict_encode64(config)}"
      end

      def validate_payment_integrity
        Fintecture::Utils::Validation.raise_if_klass_mismatch @payment_attrs, Hash, 'payment_attrs'

        raise Fintecture::ValidationException.new("access_token is a mandatory field") if @access_token.nil?

        @payment_attrs['psu_type'] = 'retail' unless @payment_attrs['psu_type']
        @payment_attrs['country'] = 'all' unless @payment_attrs['country']

        error_msg = 'invalid payment payload parameter'

        raise Fintecture::ValidationException.new("#{error_msg} type") unless Fintecture::Utils::Constants::SCOPES.include? @type
        raise Fintecture::ValidationException.new("#{@payment_attrs['psu_type']} PSU type not allowed") unless Fintecture::Utils::Constants::PSU_TYPES.include? @payment_attrs['psu_type']

        raise Fintecture::ValidationException.new('end_to_end_id must be an alphanumeric string') if(@payment_attrs['end_to_end_id'] && !@payment_attrs['end_to_end_id'].match(/^[0-9a-zA-Z]*$/))

        %w[amount currency customer_full_name customer_email customer_ip redirect_uri].each do |param|
          raise Fintecture::ValidationException.new("#{param} is a mandatory field") if @payment_attrs[param].nil?
        end

        # Check if string
        %w[communication redirect_uri].each do |param|
          Fintecture::Utils::Validation.raise_if_klass_mismatch(@payment_attrs[param], String, param) if(@payment_attrs[param])
        end

      end

      def validate_post_payment_integrity
        Fintecture::Utils::Validation.raise_if_klass_mismatch @post_payment_attrs, Hash, 'post_payment_attrs'

        %w[s state status session_id customer_id provider].each do |param|
          raise Fintecture::ValidationException.new("invalid post payment parameter #{param}") if @post_payment_attrs[param].nil?
        end
      end

      def build_payload
        attributes = {
            amount: @payment_attrs['amount'],
            currency: @payment_attrs['currency'],
            communication: @payment_attrs['communication'],
            end_to_end_id: @payment_attrs['end_to_end_id']
        }

        meta = {
            psu_name: @payment_attrs['customer_full_name'],
            psu_email: @payment_attrs['customer_email'],
            psu_ip: @payment_attrs['customer_ip']
        }

        data = {
            type: 'PAYMENT',
            attributes: attributes,
        }

        prepare_payment_response = Fintecture::Pis.prepare_payment( @access_token, {
               data: data,
               meta: meta
          })
        prepare_payment_response_body = JSON.parse(prepare_payment_response.body)
        {
            meta: {session_id: prepare_payment_response_body['meta']['session_id']},
            data: { attributes: {amount: @payment_attrs['amount'], currency: @payment_attrs['currency']}}
        }
      end

      def build_signature(payload, date, x_request_id)
        date_string = "x-date: #{date}"
        digest_string = "digest: SHA-256=#{Fintecture::Utils::Crypto.hash_base64(payload.to_json)}"
        x_request_id_string = "x-request-id: #{x_request_id}"

        Fintecture::Utils::Crypto.sign_payload "#{digest_string}\n#{date_string}\n#{x_request_id_string}"
      end

      def build_config(payload)
        header_time = Fintecture::Utils::Date.header_time
        x_request_id = Fintecture::Utils::Crypto.generate_uuid
        {
            app_id: Fintecture.app_id,
            access_token: @access_token,
            date: header_time,
            request_id: x_request_id,
            signature_type: SIGNATURE_TYPE,
            signature: build_signature(payload, header_time, x_request_id),
            redirect_uri: @payment_attrs['redirect_uri'] || '',
            origin_uri: @payment_attrs['origin_uri'] || '',
            state: @payment_attrs['state'],
            payload: payload
        }
      end

      def build_local_digest(parameters)
        test_string = {
            app_id: Fintecture.app_id,
            app_secret: Fintecture.app_secret,
            session_id: parameters['session_id'],
            status: parameters['status'],
            customer_id: parameters['customer_id'],
            provider: parameters['provider'],
            state: parameters['state']
        }.map{|key, value| "#{key}=#{value}"}.join('&')

        Fintecture::Utils::Crypto.hash_base64 test_string
      end

      def base_url
        Fintecture::Api::BaseUrl::FINTECTURE_CONNECT_URL[Fintecture.environment.to_sym]
      end

      def as_json(element)
          return JSON(element.to_json) if element.is_a? Hash

          begin
            element.as_json
          rescue NoMethodError
            raise Fintecture::ValidationException.new("invalid parameter format, the parameter should be a Hash or an Object Model instead a #{element.class.name}")
          end
      end
    end
  end
end