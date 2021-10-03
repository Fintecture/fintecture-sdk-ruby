# frozen_string_literal: true

require 'fintecture/api/ais/connect'
require 'fintecture/api/ais/accounts'
require 'fintecture/api/ais/transactions'
require 'fintecture/api/ais/account_holders'
require 'fintecture/api/ais/delete_customer'
require 'fintecture/api/ais/authorize'
require 'fintecture/api/ais/authorize_decoupled'

module Fintecture
  class AisClient
    @environment = 'sandbox'
    @environments = %w[local sandbox production].freeze

    def initialize(config)
      @app_id = config[:app_id]
      @app_secret = config[:app_secret]
      @private_key = config[:private_key]

      environment = config[:environment].downcase
      # TODO Check the environment everywhere
      # unless @environments.include?(environment)
      #   raise "#{environment} not a valid environment, options are [#{@environments.join(', ')}]"
      # end

      @environment = environment
    end

    # Getters
    attr_reader :app_id, :app_secret, :private_key, :environment, :token

    #  Methodes
    def connect(state, redirect_uri, scope = nil)
      res = Fintecture::Ais::Connect.generate self, state, redirect_uri, scope

      JSON.parse res.body
    end

    def generate_token (auth_code)
      res = Fintecture::Authentication.get_access_token self, auth_code
      body = JSON.parse res.body

      @token = body['access_token']

      body
    end

    def accounts(customer_id:, account_id: nil, remove_nulls: nil, withBalances: nil)
      res = Fintecture::Ais::Accounts.get self, customer_id, account_id, remove_nulls, withBalances

      JSON.parse res.body
    end

    def transactions(customer_id:, account_id:, remove_nulls: nil, convert_dates: nil, filters: nil)
      res = Fintecture::Ais::Transactions.get self, customer_id, account_id, remove_nulls, convert_dates, filters

      JSON.parse res.body
    end

    def account_holders(customer_id:, remove_nulls: nil)
      res = Fintecture::Ais::AccountHolders.get self, customer_id, remove_nulls

      JSON.parse res.body
    end

    def delete_customer(customer_id:)
      res = Fintecture::Ais::DeleteCustomer.delete self, customer_id

      JSON.parse res.body
    end

    def authorize(app_id_auth: false, provider_id:, redirect_uri:, state: nil, x_psu_id: nil, x_psu_ip_address: nil)
      res = Fintecture::Ais::Authorize.get self, app_id_auth, provider_id, redirect_uri, state, x_psu_id, x_psu_ip_address

      JSON.parse res.body
    end

    def authorize_decoupled(app_id_auth: false, provider_id:, polling_id:)
      res = Fintecture::Ais::AuthorizeDecoupled.get self, app_id_auth, provider_id, polling_id

      JSON.parse res.body
    end
  end
end
