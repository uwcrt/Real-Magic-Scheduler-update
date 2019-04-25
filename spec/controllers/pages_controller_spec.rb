require 'spec_helper'
describe PagesController do
  render_views

  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App | ";
  end

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      expect(response).to be_successful
    end
  end
end
