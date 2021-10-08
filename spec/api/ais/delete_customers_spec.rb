# frozen_string_literal: true

require 'json'
require 'fintecture/api/ais/delete_customer'

config = JSON.parse(File.read('./spec/api/ais/config.json'))
customer_id = config['customer_id']
code = config['code']

RSpec.describe Fintecture::Ais::DeleteCustomer do
  ais_client = Fintecture::AisClient.new({
                                           environment: config['environment'],
                                           app_id: config['app_id'],
                                           app_secret: config['app_secret'],
                                           private_key: config['private_key']
                                         })

  # ------------ TESTS ------------
  it 'DELETE /customer' do
    ais_client.generate_token code
    begin
      delete_customer_response = ais_client.delete_customer customer_id: 'xxxxxxxx'
      meta = delete_customer_response['meta']

      expect(meta['code']).to eq('customer_deleted')
      expect(meta['status']).to eq(200)
    rescue StandardError => e
      exception = JSON.parse e.to_s
      error = exception['errors'].first

      expect(error['code']).to eq('customer_unknown')
      expect(error['title']).to eq('Customer ID invalid')
    end
  end
end
