# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Finance::Application.initialize!

Finance::Application.config.currency_list = ['UAH', 'USD', 'EUR']