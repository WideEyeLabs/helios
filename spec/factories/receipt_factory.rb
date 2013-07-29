require 'factory_girl'

def random_string
  rand(36**8).to_s(36)
end

FactoryGirl.define do
  factory :inapp_receipt, :class => Rack::InAppPurchase::Receipt do
    quantity                    1
    product_id                  'com.xyz.inapp.product'
    transaction_id              { random_string }
    purchase_date               { Date.today }
    original_transaction_id     { random_string }
    original_purchase_date      { Date.today }
    app_item_id                 'com.xyz.inapp.product'
    version_external_identifier 'com.xyz.inapp.product'
    bid                         { random_string }
    bvrs                        { random_string }
    ip_address                  '127.0.0.1'
    created_at                  { Date.today.prev_day }
    to_create { |instance| instance.save }
  end
end
