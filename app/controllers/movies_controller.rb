class MoviesController < ApplicationController

  def index
    movies = Movie.all

    if movie_params[:sort]
      movies = movies.order(movie_params[:sort] => :asc)
    end

    if movie_params[:n] || movie_params[:p]
      query_check
      movies = movies.paginate(page: movie_params[:p], per_page: movie_params[:n])
    end

    render json: movies.as_json(only: [:id, :title, :release_date]), status: :ok
  end

  def show
    movie = Movie.find_by(id: params[:id])

    if movie.nil?
      render json: { message: "Movie not found" }, status: :not_found
    else
      render json: movie.as_json(except: [:id, :created_at, :updated_at]), status: :ok
    end
  end

  def create
    movie = Movie.new(movie_params)

    if movie.save
      render json: movie.as_json(only: [:id]), status: :ok
    else
      render json: { errors: movie.errors.messages }, status: :bad_request
    end
  end

  private

    def movie_params
      params.permit(:title, :overview, :release_date, :inventory, :available_inventory, :sort, :n, :p)
    end

    def query_check
      if movie_params[:n] && !movie_params[:p]
        return movie_params[:p] = 1
      end

      if movie_params[:p] && !movie_params[:n]
        return movie_params[:n] = 10
      end
    end

end
