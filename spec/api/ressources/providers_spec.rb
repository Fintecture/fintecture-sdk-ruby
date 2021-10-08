# frozen_string_literal: true

require 'json'
require 'fintecture/api/ressources/providers'

config = JSON.parse(File.read('./spec/api/pis/config.json'))

RSpec.describe Fintecture::Ressources::Providers do
  pis_client = Fintecture::PisClient.new({
                                           environment: config['environment'],
                                           app_id: config['app_id'],
                                           app_secret: config['app_secret'],
                                           private_key: config['private_key']
                                         })

  paramsProviders = {
    'filter[country]': 'FR',
    'filter[pis]': 'SEPA',
    'filter[ais]': 'Accounts',
    'filter[psu_type]': 'retail',
    'filter[auth_model]': 'redirect',
    'sort[name]': 'DESC',
    'sort[full_name]': 'DESC',
    'sort[country]': 'DESC',
    'sort[provider_id]': 'DESC'
  }

  # ------------ TESTS ------------
  it 'GET /providers' do
    providers_response = pis_client.providers
    first_provider = providers_response['data'].first

    expect(first_provider['type']).to eq('provider')
  end

  it 'GET /providers/[provider_id]' do
    providers_response = pis_client.providers provider_id: 'agfbfr'
    first_provider = providers_response['data'].first

    expect(first_provider['type']).to eq('provider')
    expect(first_provider['id']).to eq('agfbfr')
  end

  it 'GET /providers + paramsProviders' do
    providers_response = pis_client.providers paramsProviders: paramsProviders
    first_provider = providers_response['data'].first
    attributes = first_provider['attributes']

    expect(first_provider['type']).to eq('provider')
    expect(attributes['country']).to eq('FR')
  end
end
