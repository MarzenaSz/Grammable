class GramsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  
  def index
     @grams = Gram.all
  end

  def update
    @gram = Gram.find_by_id(params[:id])
    return render_not_found if @gram.blank?
    return render_not_found(:forbidden) if @gram.user != current_user

    @gram.update_attributes(gram_params)
    if @gram.valid?
      redirect_to root_path
    else
      return render :edit, status: :unprocessable_entity
    end
  end

  def show
    @gram = Gram.find_by_id(params[:id])
    return render_not_found if @gram.blank?
  end

  def edit
    @gram = Gram.find_by_id(params[:id])
    return render_not_found if @gram.blank?
    return render_not_found(:forbidden) if @gram.user != current_user
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

  def destroy
    @gram = Gram.find_by_id(params[:id])
    return render_not_found if @gram.blank?
    return render_not_found(:forbidden) if @gram.user != current_user
    
    @gram.destroy
    redirect_to root_path
  end


  private

  def gram_params
    params.require(:gram).permit(:message, :picture)
  end

end
