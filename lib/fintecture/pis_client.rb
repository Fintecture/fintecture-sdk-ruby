# frozen_string_literal: true

require 'fintecture/api/pis/connect'
require 'fintecture/api/pis/request_to_pay'
require 'fintecture/api/pis/payments'
require 'fintecture/api/pis/initiate'
require 'fintecture/api/pis/refund'
require 'fintecture/api/pis/settlements'

require 'fintecture/api/ressources/providers'
require 'fintecture/api/ressources/applications'
require 'fintecture/api/ressources/test_accounts'

module Fintecture
  class PisClient
    @environment = %w[local test sandbox production].freeze

    def initialize(config)
      @app_id = config[:app_id]
      @app_secret = config[:app_secret]
      @private_key = config[:private_key]

      environment = config[:environment].downcase
      unless environment.include?(environment)
        raise "#{environment} not a valid environment, options are [#{environment.join(', ')}]"
      end

      @environment = config[:environment]
    end

    # Getters
    attr_reader :app_id, :app_secret, :private_key, :environment, :token, :token_expires_in

    #  Methodes
    def generate_token
      res = Fintecture::Authentication.get_access_token self
      body = JSON.parse res.body

      @token = body['access_token']
      @token_expires_in = body['expires_in']

      body
    end

    def connect(payload, state, redirect_uri = nil, origin_uri = nil, **options)
      res = Fintecture::Pis::Connect.generate self, Marshal.load(Marshal.dump(payload)), state, redirect_uri, origin_uri, options

      JSON.parse res.body
    end

    def request_to_pay(payload, x_language, redirect_uri = nil)
      res = Fintecture::Pis::RequestToPay.generate self, Marshal.load(Marshal.dump(payload)), x_language, redirect_uri

      JSON.parse res.body
    end

    def initiate(payload, provider_id, redirect_uri, state = nil)
      res = Fintecture::Pis::Initiate.generate self, Marshal.load(Marshal.dump(payload)), provider_id, redirect_uri,
                                               state

      JSON.parse res.body
    end

    def payments(session_id = nil, **options)
      res = Fintecture::Pis::Payments.get self, session_id, options

      JSON.parse res.body
    end

    def refund(session_id, amount = nil, user_id = nil)
      res = Fintecture::Pis::Refund.generate self, session_id, amount, user_id

      JSON.parse res.body
    end

    def settlements(settlement_id = nil, include_payments = false)
      res = Fintecture::Pis::Settlements.get self, settlement_id, include_payments

      JSON.parse res.body
    end

    def providers(provider_id: nil, paramsProviders: nil)
      res = Fintecture::Ressources::Providers.get self, provider_id, paramsProviders

      JSON.parse res.body
    end

    def applications
      res = Fintecture::Ressources::Applications.get self

      JSON.parse res.body
    end

    def test_accounts(provider_id = nil)
      res = Fintecture::Ressources::TestAccounts.get self, provider_id

      JSON.parse res.body
    end
  end
end
