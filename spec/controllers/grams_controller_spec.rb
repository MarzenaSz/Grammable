require 'rails_helper'

RSpec.describe GramsController, type: :controller do
  # Test for our show page
  describe "grams#show action" do
    it "should successfully show the page if the gram is found" do
      # Push a new gram into the database
      gram = FactoryGirl.create(:gram)
      # Trigger an HTTP GET request to /grams/:id, where the id is replaced by the gram we just created 
      get :show, params: { id: gram.id }
      # Expect the response to have a successful HTTP status code
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the gram is not found" do
      get :show, params: { id: 'TACOCAT' }
      expect(response).to have_http_status(:not_found)
    end
  end

  # Test for our root page
  describe "grams#index action" do

    it "should successfully show the page" do
      # Trigger an HTTP GET request to the index action of the controller
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  # Test for new form page
  describe "grams#new action" do

    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form" do
      # Create a user using FactoryGirl before the action in our controller
      user = FactoryGirl.create(:user)
      sign_in user
      # Trigger an HTTP GET request to the new action of the controller
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  # Test for create form page
  describe "grams#create action" do

    it "should require users to be logged in" do
      post :create, params: { gram: { message: "Hello" } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully create a new gram in our database" do
      # Create a user before the action in our controller
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, params: { gram: { message: 'Hello!' } }
      expect(response).to redirect_to root_path
      # Expect the message of the gram to equal Hello!
      gram = Gram.last
      expect(gram.message).to eq("Hello!")
      # Make sure the user_id on the gram matches the signed in user's id
      expect(gram.user).to eq(user)
    end
    # Test for validation errors
    it "should properly deal with validation errors" do
      # Create a user before the action in our controller
      user = FactoryGirl.create(:user)
      sign_in user

      gram_count = Gram.count
      post :create, params: { gram: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(gram_count).to eq 0
    end
  end

end
