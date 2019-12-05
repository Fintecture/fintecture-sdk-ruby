module Fintecture
  module Api
    module Errors
      class FintectureError
        attr_reader :response

        def initialize(message, response = nil)
          @response = response
          super message
        end
      end
    end
  end
end
