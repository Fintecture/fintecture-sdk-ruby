# frozen_string_literal: true

require 'fintecture/api/ais/connect'

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





  end
end
