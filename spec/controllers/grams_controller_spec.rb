require 'rails_helper'

RSpec.describe GramsController, type: :controller do
  # Test for our root page
  describe "grams#index action" do

    it "should successfully show the page" do
      # triggers an HTTP GET request to the index action of the controller
      get :index
      expect(response).to have_http_status(:success)
    end

  end

end
