require 'lib/fintecture'

Fintecture.app_id = 'app_id'
Fintecture.app_secret = 'app_secret'
Fintecture.app_private_key = 'app_private_key'
Fintecture.environment = 'sandbox'

payment_attrs = {
    amount: 0.5,
    currency: 'EUR',
    order_id: '123',
    customer_id: '123',
    customer_full_name: 'John Doe',
    customer_email: 'john.doe@email.com',
    customer_ip: '127.0.0.1'
}

config = {
    redirect_uri: 'http://example.com',
    origin_uri: 'http://example.com'
}

Fintecture::Connect.connect_url(payment_attrs: payment_attrs, config: config, type: 'pis')