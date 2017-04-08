require 'rails_helper'

RSpec.describe GramsController, type: :controller do
   # Test for our update page
  describe "grams#update action" do
    it "should allow users to successfully update grams" do
      # Create a gram and specify the message to be "Initial Value"
      gram = FactoryGirl.create(:gram, message: "Initial Value")
      # Trigger an HTTP PATCH request to the update action and use the form data to be "Changed".
      patch :update, params: { id: gram.id, gram: { message: 'Changed' } }
      # Redirect to the home page
      expect(response).to redirect_to root_path
      gram.reload
      expect(gram.message).to eq "Changed"
    end

    it "should have http 404 error if the gram cannot be found" do
      patch :update, params: { id: "YOLOSWAG", gram: { message: 'Changed' } }
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity" do
      # Create a gram in the database with the message Initial Value
      gram = FactoryGirl.create(:gram, message: "Initial Value")
      # Perform an HTTP PATCH request to the update action, but with the message the empty string
      patch :update, params: { id: gram.id, gram: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      # Reload our gram from the database to make sure it has it's latest value
      gram.reload
      expect(gram.message).to eq "Initial Value"
    end
  end
  # Test for our edit page
  describe "grams#edit action" do
    it "should successfully show the edit form if the gram is found" do
      gram = FactoryGirl.create(:gram)
      get :edit, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error message if the gram is not found" do
      get :edit, params: { id: 'SWAG' }
      expect(response).to have_http_status(:not_found)
    end
  end
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
