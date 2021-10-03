# frozen_string_literal: true

require 'logger'
require 'uri'
require 'faraday'

# ToRemove
require 'openssl'
require 'cgi'

# Version
require 'fintecture/version'

# Modules
require 'fintecture/api/auth/authentication'

# Clients
require 'fintecture/pis_client'
require 'fintecture/ais_client'

# Utilities
require 'fintecture/utils/crypto'

# Endpoints
require 'fintecture/base_url'
require 'fintecture/endpoints/authentication'
require 'fintecture/endpoints/ais'
require 'fintecture/endpoints/pis'
require 'fintecture/endpoints/ressources'

# Connections
require 'fintecture/faraday/authentication/connection'

module Fintecture
  @log_level = nil
  @logger = nil


  class << self
    attr_accessor :logger
    attr_reader :log_level

    # Logging
    LEVEL_DEBUG = Logger::DEBUG
    LEVEL_ERROR = Logger::ERROR
    LEVEL_INFO = Logger::INFO

    def log_level=(val)
      case val
      when 'debug'
        val = LEVEL_DEBUG
      when 'info'
        val = LEVEL_INFO
      end

      if !val.nil? && ![LEVEL_DEBUG, LEVEL_ERROR, LEVEL_INFO].include?(val)
        raise ArgumentError, 'log_level should only be set to `nil`, `debug` or `info`'
      end

      @log_level = val
    end
  end
end

Fintecture.log_level = ENV['FINTECTURE_LOG'] unless ENV['FINTECTURE_LOG'].nil?
# TODO Mettre a jour la gem sur le site de package