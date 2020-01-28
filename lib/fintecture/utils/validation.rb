require 'fintecture/exceptions'

module Fintecture
  module Utils
    class Validation
      class << self

        def raise_if_klass_mismatch(target, klass, param_name = nil)
          return if target.is_a? klass

          raise Fintecture::ValidationException.new("invalid #{param_name ? param_name : 'parameter'} format, the parameter should be a #{klass} instead a #{target.class.name}")
        end

      end
    end
  end
end