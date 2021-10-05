# frozen_string_literal: true

require 'json'

module Fintecture
  class ValidationException < RuntimeError; end

  class CryptoException < RuntimeError; end

  class ApiException
    class << self
      def error(res)
        body = JSON.parse res.body

        # Errors array
        if body['code'] && body['log_id'] && body['errors']
          raise _construct_message_errors(res, body)
        # Single error
        else
          raise _construct_message_error(res, body)
        end
      end

      private

      def _construct_message_errors(res, body)
        status = res.status
        code = body['code']
        log_id = body['log_id']
        errors_array = body['errors']

        error_string = "\nFintecture server errors : "
        error_string += "\n status: #{status} "
        error_string += "\n code: #{code}"
        error_string += "\n id : #{log_id}"

        errors_array.each do |error|
          formated_error = error.map { |key, value| "   #{key}: #{value}" }.join("\n")
          error_string += "\n\n#{formated_error}"
        end
        error_string += "\n\n"

        
        {
          type: "Fintecture api",
          status: status,
          errors: errors_array,
          error_string: error_string
        }.to_json
      end

      def _construct_message_error(res, body)
        status = res.status
        error = body['meta']

        error_string = "\nFintecture server errors : "
        error_string += "\n status: #{status} "

        formated_error = error.map { |key, value| "   #{key}: #{value}" }.join("\n")
        error_string += "\n\n#{formated_error}"

        error_string += "\n\n"

        {
          type: "Fintecture api",
          status: status,
          errors: [error],
          error_string: error_string
        }.to_json
        
      end



    end
  end
end
