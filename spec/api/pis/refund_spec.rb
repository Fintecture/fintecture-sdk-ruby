# frozen_string_literal: true

require 'json'
require 'fintecture/api/pis/refund'

config = JSON.parse(File.read('./spec/api/pis/config.json'))

RSpec.describe Fintecture::Pis::Refund do
  pis_client = Fintecture::PisClient.new({
                                           environment: config['environment'],
                                           app_id: config['app_id'],
                                           app_secret: config['app_secret'],
                                           private_key: config['private_key']
                                         })

  it 'POST /refund 1€' do
    pis_client.generate_token

    begin
      initiate_response = pis_client.refund '4cfbaeb21b2b408cbcd44ac0d6660ac7', "1"
      meta = initiate_response['meta']

      expect(meta['status']).to eq(200)
      expect(meta['code']).to eq('refund_accepted')
    rescue StandardError => e
      exception = JSON.parse e.to_s
      error = exception['errors'].first

      expect(error['code']).to eq('refund_aborted')
      expect(error['status']).to eq(400)
    end
  end

  it 'POST /refund all' do
    pis_client.generate_token

    begin
      initiate_response = pis_client.refund '4cfbaeb21b2b408cbcd44ac0d6660ac7'
      meta = initiate_response['meta']

      expect(meta['status']).to eq(200)
      expect(meta['code']).to eq('refund_accepted')
    rescue StandardError => e
      exception = JSON.parse e.to_s
      error = exception['errors'].first

      expect(error['code']).to eq('refund_aborted')
      expect(error['status']).to eq(400)
    end
  end
end
