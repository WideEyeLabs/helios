require 'factory_girl'

# convenience method to generate a random
# fake device token
def generate_token
  token = '<'
  8.times do
    token << "%08x" % (rand * 0xffffff) + ' '
  end
  token[token.length-1] = '>'

  token
end

FactoryGirl.define do
  factory :device, :class => Rack::PushNotification::Device do
    token      { generate_token }
    badge      0
    locale     'US'
    language   'en'
    timezone   'America/New_York'
    ip_address '127.0.0.1'
    lat        '45.10'
    lng        '-85.10'
    tags       '{"iphone", "4S"}'
    to_create {|instance| instance.save }
  end
end
