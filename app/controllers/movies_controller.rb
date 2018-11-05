class MoviesController < ApplicationController
  def index
    movies = Movie.all
    render json: movies.as_json(except: [:created_at, :updated_at]), status: :ok
  end

  def show
  end

  def create
  end
end
