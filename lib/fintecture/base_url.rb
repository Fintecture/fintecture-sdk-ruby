module Fintecture
  module Api
    module BaseUrl
      FINTECTURE_OAUTH_URL = {
        local: 'http://localhost:3333/oauth',
        test: 'https://oauth-sandbox-test.fintecture.com/oauth',
        sandbox: 'https://api-sandbox.fintecture.com/oauth',
        production: 'https://api.fintecture.com/oauth'
      }

      FINTECTURE_API_URL = {
        local: 'http://localhost:3333',
        test: 'https://api-sandbox-test.fintecture.com',
        sandbox: 'https://api-sandbox.fintecture.com',
        production: 'https://api.fintecture.com'
      }

      FINTECTURE_CONNECT_URL = {
        local: 'http://localhost:4242',
        test: 'https://connect-test.fintecture.com',
        sandbox: 'https://connect-sandbox.fintecture.com',
        production: 'https://connect.fintecture.com'
      }
    end
  end
end
