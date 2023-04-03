class RecipesController < ApplicationController
  before_action :authorize 
  
  def index 
    recipes = Recipe.all
    render json: recipes
  end

  def create
    params[:user_id] = session[:user_id]
    recipe = Recipe.create!(recipe_params)
    render json: recipe, status: :created 
  rescue ActiveRecord::RecordInvalid => invalid 
    render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
  end

  private
  def recipe_params
    params.permit(:title, :instructions, :user_id, :minutes_to_complete)
  end
  def authorize 
    render json: {errors: ["Unauthorized"]}, status: :unauthorized unless session.include? :user_id
  end


end