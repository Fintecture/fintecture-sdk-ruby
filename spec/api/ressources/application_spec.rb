# frozen_string_literal: true

require 'json'
require 'fintecture/api/ressources/applications'

config = JSON.parse(File.read('./spec/api/pis/config.json'))

RSpec.describe Fintecture::Ressources::Applications do
  pis_client = Fintecture::PisClient.new({
    environment: config['environment'],
    app_id: config['app_id'],
    app_secret: config['app_secret'],
    private_key: config['private_key']
  })

  # ------------ TESTS ------------
  it 'GET /applications' do
    applications_response = pis_client.applications
    data = applications_response['data']

    expect(data['type']).to eq('app')
  end
end
