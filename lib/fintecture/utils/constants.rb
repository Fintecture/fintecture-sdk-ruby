# frozen_string_literal: true

module Fintecture
  module Utils
    module Constants
      SIGNEDHEADERPARAMETERLIST = %w[(request-target) Date Digest X-Request-ID].freeze
      PSU_TYPES = %w[retail corporate all].freeze
      SCOPES = %w[pis ais].freeze
    end
  end
end
