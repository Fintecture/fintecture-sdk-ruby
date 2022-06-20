# frozen_string_literal: true

require 'json'

module Fintecture
  class ValidationException < RuntimeError; end

  class CryptoException < RuntimeError; end

  class ApiException
    class << self
      def error(res)
        body = JSON.parse res.body

        raise construct_message_errors(res.status, body)
      end

      private

      def construct_message_errors(status, body)
        code = body['code'].presence
        log_id = body['log_id'].presence
        errors_array = body['errors'].presence || body['meta'].presence || []

        error_string = "\nFintecture server errors : "
        error_string += "\n status: #{status} " if status
        error_string += "\n code: #{code}" if code
        error_string += "\n id : #{log_id}" if log_id

        errors_array.compact!
        errors_array.each do |error|
          formated_error = error
          formated_error = error.map { |key, value| "   #{key}: #{value}" }.join("\n") if error.is_a?(Hash)
          error_string += "\n\n#{formated_error}"
        end

        error_string += "\n\n"

        {
          type: 'Fintecture api',
          status: status,
          errors: errors_array,
          error_string: error_string
        }.to_json
      end
    end
  end
end
