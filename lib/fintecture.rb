require 'logger'
require 'uri'
require 'faraday'

#ToRemove
require 'openssl'
require 'cgi'

# Version
require 'fintecture/version'

# Modules
require 'fintecture/connect'
require 'fintecture/authentication'

# Utilities
require 'fintecture/utils/crypto'

# Endpoints
require 'fintecture/api/base_url'
require 'fintecture/api/endpoints/authentication'

# Connections
require 'fintecture/faraday/authentication/connection'


module Fintecture
  @log_level = nil
  @logger = nil
  @environment = 'sandbox'

  ENVIRONMENTS = %w[local test sandbox production].freeze

  class << self
    attr_accessor :app_id, :app_secret, :private_key

    def environment=(environment)
      environment = environment.downcase

      raise "#{environment} not a valid environment, options are [#{ENVIRONMENTS.join(', ')}]" unless ENVIRONMENTS.include?(environment)

      @environment = environment
    end

    def environment
      @environment
    end

    # Logging
    LEVEL_DEBUG = Logger::DEBUG
    LEVEL_ERROR = Logger::ERROR
    LEVEL_INFO = Logger::INFO

    def log_level
      @log_level
    end

    def log_level=(val)
      if val == "debug"
        val = LEVEL_DEBUG
      elsif val == "info"
        val = LEVEL_INFO
      end

      if !val.nil? && ![LEVEL_DEBUG, LEVEL_ERROR, LEVEL_INFO].include?(val)
        raise ArgumentError, 'log_level should only be set to `nil`, `debug` or `info`'
      end
      @log_level = val
    end

    def logger
      @logger
    end

    def logger=(val)
      @logger = val
    end

  end
end

Fintecture.log_level = ENV["FINTECTURE_LOG"] unless ENV["FINTECTURE_LOG"].nil?