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

  # Test for new form page
  describe "grams#new action" do
    it "should successfully show the new form" do
      # triggers an HTTP GET request to the new action of the controller
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  # Test for create form page
  describe "grams#create action" do
    it "should successfully create a new gram in our database" do
      post :create, params: { gram: { message: 'Hello!' } }
      expect(response).to redirect_to root_path
      # Expect the message of the gram to equal Hello!
      gram = Gram.last
      expect(gram.message).to eq("Hello!")
    end
    # Test for validation errors
    it "should properly deal with validation errors" do
      post :create, params: { gram: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Gram.count).to eq 0
    end
  end

end
