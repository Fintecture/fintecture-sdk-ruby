# frozen_string_literal: true

require 'time'

module Fintecture
  module Utils
    class Date
      class << self
        def header_time
          Time.now.utc.strftime('%a, %d %b %Y %H:%M:%S GMT')
        end
      end
    end
  end
end
