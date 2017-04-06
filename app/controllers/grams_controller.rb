class GramsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  
  def index

  end

  def show
    @gram = Gram.find_by_id(params[:id])
    if @gram.blank?
      render plain: 'Not Found :(', status: :not_found
    end
  end

  def new
    # Create a new gram
    @gram = Gram.new
  end

  def create
    # connect this gram to current user
    @gram = current_user.grams.create(gram_params)
    # Check if gram is valid (the user typed something in a text field)
    # if it is then redirect user to the home page
    # otherwise stay on new page and show unprocessable_entity message
    if @gram.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end


  private

  def gram_params
    params.require(:gram).permit(:message)
  end
  
end
