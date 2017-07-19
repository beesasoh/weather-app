#initializer logs
 
if Rails.env == 'test'

    LOGGER = Logger.new('log/test/info.log')
elsif Rails.env == 'development'

    LOGGER = Logger.new('log/development/info.log')
elsif Rails.env == 'production'

    LOGGER = Logger.new('log/production/info.log')
end