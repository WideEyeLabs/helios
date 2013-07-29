require 'spec_helper'

describe "Dashboard", :js => true do
  it "should have a header titled 'Data'", :driver => :poltergeist do
    visit '/admin'

    page.should have_content 'Data'
  end

  it "should show a dropdown when '#entities-dropdown' is clicked", :driver => :selenium do
    visit '/admin'
    page.click_link('#entities-dropdown')

    page.should have_content 'Products'
  end
end
