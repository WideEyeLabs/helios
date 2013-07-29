require 'spec_helper'
require 'base64'

describe "Inapp Purchase Api" do
  it "should return a list of product identifiers when I do a GET on /in_app_purchase/products" do
    prod_one = FactoryGirl.create(:inapp_product)
    prod_two = FactoryGirl.create(:inapp_product)

    get "/in_app_purchase/products/identifiers"
    expected_json = [prod_one.product_identifier, prod_two.product_identifier].to_json

    last_json.should be_json_eql expected_json
  end

  it "should return a new product when I POST to /in_app_purchase/products" do
    product = FactoryGirl.create(:inapp_product)
    expected_json = {:product => product.values}.to_json
    post "/in_app_purchase/products", product.values

    last_json.should be_json_eql expected_json
  end

  it "should return a product when I do a GET on /in_app_purchase/products/:product_identifier" do
    product = FactoryGirl.create(:inapp_product)
    expected_json = {:product => product.values}.to_json
    get "/in_app_purchase/products/#{product.product_identifier}"

    last_json.should be_json_eql expected_json
  end

  it "should return a 404 when I do a GET on /in_app_purchase/products/:product_identifier that doesn't exist" do
    get "/in_app_purchase/products/com.fake.identifier"

    last_response.status.should be 404
  end

  it "should return a list of receipts when I do a GET on /in_app_purchase/receipts" do
    receipt_one = FactoryGirl.create(:inapp_receipt)
    receipt_two = FactoryGirl.create(:inapp_receipt)
    expected_json = {:receipts => [receipt_one.values, receipt_two.values]}.to_json
    get "/in_app_purchase/receipts"

    last_json.should be_json_eql expected_json
  end

  it "should return a 203 when I do a POST to /in_app_purchase/receipts/verify with valid receipt-data" do
    receipt = FactoryGirl.create(:inapp_receipt)
    receipt_data = Base64.encode64(receipt.values.to_json)

    receipt.stub(:to_h).and_return(receipt.values)
    mock_client = double("Venice::Client")
    mock_client.stub(:verify!).and_return(receipt)
    Venice::Client.stub(:production).and_return(mock_client)

    post "/in_app_purchase/receipts/verify", "receipt-data=#{receipt_data}", 'Content-Type' => 'x-www-formurlencoded'

    last_response.status.should be 203
  end
end
