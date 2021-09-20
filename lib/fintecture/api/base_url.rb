module Fintecture
  module Api
    module BaseUrl

      FINTECTURE_OAUTH_URL = {
          local: 'http://localhost:3030/oauth',
          test: 'https://oauth-sandbox-test.fintecture.com/oauth',
          sandbox: 'https://api-sandbox-test.fintecture.com/oauth',
          production: 'https://oauth.fintecture.com/oauth'
      }

      FINTECTURE_API_URL = {
          local: 'http://localhost:3030',
          test: 'https://api-sandbox-test.fintecture.com',
          sandbox: 'https://api-sandbox-test.fintecture.com',
          production: 'https://api.fintecture.com'
      }

      FINTECTURE_CONNECT_URL = {
          local: 'http://localhost:4201',
          test: 'https://connect-test.fintecture.com',
          sandbox: 'https://connect-sandbox.fintecture.com',
          production: 'https://connect.fintecture.com'
      }


    end
  end
end