# frozen_string_literal: true

require 'json'
require 'fintecture/api/ais/authorize'

config = JSON.parse(File.read('./spec/api/ais/config.json'))
customer_id = config["customer_id"]
code = config["code"]

RSpec.describe Fintecture::Ais::Authorize do
  ais_client = Fintecture::AisClient.new({
    environment: config['environment'],
    app_id: config['app_id'],
    app_secret: config['app_secret'],
    private_key: config['private_key']
  })


  it 'GET /authorize - Token auth' do
    ais_client.generate_token code
    
    authorize_response = ais_client.authorize app_id_auth: false, provider_id: "agfbfr", redirect_uri: "https://www.google.fr", state: nil, x_psu_id: nil, x_psu_ip_address: nil

    expect(authorize_response['provider']).to eq('agfbfr')
    expect(authorize_response['model']).to eq('redirect')
    expect(authorize_response['url']).not_to be_empty
  end

  it 'GET /authorize - Token auth + optional state' do
    ais_client.generate_token code
    
    authorize_response = ais_client.authorize app_id_auth: false, provider_id: "agfbfr", redirect_uri: "https://www.google.fr", state: "ok", x_psu_id: nil, x_psu_ip_address: nil

    expect(authorize_response['provider']).to eq('agfbfr')
    expect(authorize_response['model']).to eq('redirect')
    expect(authorize_response['url']).not_to be_empty
  end

  it 'GET /authorize - Token auth + optional state & x_psu_id' do
    ais_client.generate_token code
    
    authorize_response = ais_client.authorize app_id_auth: false, provider_id: "agfbfr", redirect_uri: "https://www.google.fr", state: "ok", x_psu_id: "1234", x_psu_ip_address: nil

    expect(authorize_response['provider']).to eq('agfbfr')
    expect(authorize_response['model']).to eq('redirect')
    expect(authorize_response['url']).not_to be_empty
  end

  it 'GET /authorize - Token auth + optional state & x_psu_id & x_psu_ip_address' do
    ais_client.generate_token code
    
    authorize_response = ais_client.authorize app_id_auth: false, provider_id: "agfbfr", redirect_uri: "https://www.google.fr", state: "ok", x_psu_id: "1234", x_psu_ip_address: "192.168.1.1"

    expect(authorize_response['provider']).to eq('agfbfr')
    expect(authorize_response['model']).to eq('redirect')
    expect(authorize_response['url']).not_to be_empty
  end








  it 'GET /authorize - Code auth' do
    ais_client.generate_token code
    
    authorize_response = ais_client.authorize app_id_auth: true, provider_id: "agfbfr", redirect_uri: "https://www.google.fr", state: nil, x_psu_id: nil, x_psu_ip_address: nil

    expect(authorize_response['provider']).to eq('agfbfr')
    expect(authorize_response['model']).to eq('redirect')
    expect(authorize_response['url']).not_to be_empty
  end

  it 'GET /authorize - Code auth + optional state' do
    ais_client.generate_token code
    
    authorize_response = ais_client.authorize app_id_auth: true, provider_id: "agfbfr", redirect_uri: "https://www.google.fr", state: "ok", x_psu_id: nil, x_psu_ip_address: nil

    expect(authorize_response['provider']).to eq('agfbfr')
    expect(authorize_response['model']).to eq('redirect')
    expect(authorize_response['url']).not_to be_empty
  end

  it 'GET /authorize - Code auth + optional state & x_psu_id' do
    ais_client.generate_token code
    
    authorize_response = ais_client.authorize app_id_auth: true, provider_id: "agfbfr", redirect_uri: "https://www.google.fr", state: "ok", x_psu_id: "1234", x_psu_ip_address: nil

    expect(authorize_response['provider']).to eq('agfbfr')
    expect(authorize_response['model']).to eq('redirect')
    expect(authorize_response['url']).not_to be_empty
  end
  
  it 'GET /authorize - Code auth + optional state & x_psu_id & x_psu_ip_address' do
    ais_client.generate_token code
    
    authorize_response = ais_client.authorize app_id_auth: true, provider_id: "agfbfr", redirect_uri: "https://www.google.fr", state: "ok", x_psu_id: "1234", x_psu_ip_address: "192.168.1.1"
    
    expect(authorize_response['provider']).to eq('agfbfr')
    expect(authorize_response['model']).to eq('redirect')
    expect(authorize_response['url']).not_to be_empty
  end



end
