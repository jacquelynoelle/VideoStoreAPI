class MoviesController < ApplicationController
  def index
    movies = Movie.all

    movies = sort_and_paginate(movies, movie_params)

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

    def rentals_list(criteria)
      movie = Movie.find_by(id: params[:id].to_i)

      list = movie.send(criteria).map do |rental|
        {
          customer_id: rental.customer_id,
          checkout_date: rental.checkout_date,
          due_date: rental.due_date,
          name: rental.customer.name,
          postal_code: rental.customer.postal_code
        }
      end

      list = sort_and_paginate(list, movie_params)

      render json: list.as_json, status: :ok
    end
end
