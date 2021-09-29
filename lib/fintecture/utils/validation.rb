# frozen_string_literal: true

require 'fintecture/exceptions'

module Fintecture
  module Utils
    class Validation
      class << self
        def raise_if_klass_mismatch(target, klass, param_name = nil)
          return if target.is_a? klass

          raise Fintecture::ValidationException,
                "invalid #{param_name || 'parameter'} format, the parameter should be a #{klass} instead a #{target.class.name}"
        end

        def raise_if_invalid_date_format(date)
          return unless date

          valid_format = date.match(/\d{4}-\d{2}-\d{2}/)
          valid_date = begin
            ::Date.strptime(date, '%Y-%m-%d')
          rescue StandardError
            false
          end
          return if valid_format && valid_date

          raise Fintecture::ValidationException, "invalidss #{date} date, the format should be YYYY-MM-DD"
        end
      end
    end
  end
end
