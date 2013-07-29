require 'spec_helper'

describe "Push Notification Api" do
  it "should return a new device when I do a POST on /push_notification/devices" do
    post "/push_notification/devices", FactoryGirl.build(:device).values.merge(:alias => 'alias')

    json_hash["device"].should_not be_nil
  end

  it "should return a list of devices when I do a GET on /push_notification/devices" do
    FactoryGirl.create(:device)
    get "/push_notification/devices"

    json_hash["devices"].should_not be_nil
  end

  it "should return a 200 when I do a DELETE on /device/:token" do
    device = FactoryGirl.create(:device)
    delete "/push_notification/devices/#{device.token}"

    last_response.status.should be 200
  end

  xit "should send a push notification when I do a POST on /push_notification/message" do
    devices = Array.new

    3.times do
      devices << FactoryGirl.create(:device)
    end

    tokens = devices.collect { |device| device.token + ',' }
    post "/push_notification/message", 'payload={"aps":{"alert":"hello"}}&tokens=' + "#{tokens}", 'Content-Type' => 'x-www-formurlencoded'

    last_response.status.should be 201
  end
end
