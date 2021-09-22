module Fintecture
  class ValidationException < Exception; end
  class CryptoException < Exception; end
  class ApiException
    class << self

      def error(res)
        body = JSON.parse res.body
        raise Exception.new(_construct_message(res.status, body['code'], body['log_id'], body["errors"]))
      end


      private 
      def _construct_message(status, code, log_id, errors_array)
        error_string = "\nFintecture server errors : "
        error_string += "\n status: #{status} "
        error_string += "\n code: #{code}"
        error_string += "\n id : #{log_id}"
        errors_array.each do |error|
          formated_error = error.map {|key,value| "   #{key}: #{value}"}.join("\n")
          error_string += "\n\n#{formated_error}"
        end
        error_string += "\n\n"
        error_string
      end
    end
  end
end