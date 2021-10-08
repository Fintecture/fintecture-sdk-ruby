# frozen_string_literal: true

require './lib/fintecture'

# ------------ Test class -------------
config = JSON.parse(File.read('./exemples/config_pis.json'))

pis_client = Fintecture::PisClient.new({
                                         environment: config['environment'],
                                         app_id: config['app_id'],
                                         app_secret: config['app_secret'],
                                         private_key: config['private_key']
                                       })

# ######################## RESSOURCES ########################
# ------------ Get providers ------------
puts pis_client.providers provider_id: 'agfbfr'
puts pis_client.providers paramsProviders: paramsProviders
# ------------ Get applications ------------
puts pis_client.applications
# ------------ Get test accounts ------------
puts pis_client.test_accounts
puts pis_client.test_accounts 'bbvaes'
