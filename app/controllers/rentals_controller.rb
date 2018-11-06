require 'date'

class RentalsController < ApplicationController
  def checkout
    rental = Rental.new(rental_params)

    if rental.checkout?
      render json: rental.as_json(except: [:created_at, :updated_at]), status: :ok
    else
      render json: { errors: rental.errors.messages }, status: :bad_request
    end
  end

  def checkin
    rental = Rental.find_by(movie_id: params[:movie_id], customer_id: params[:customer_id])

    if rental.nil?
      render json: { message: "Rental not found" }, status: :not_found
    elsif rental.checkin?
      render json: rental.as_json(except: [:created_at, :updated_at]), status: :ok
    else
      render json: { message: "Could not check-in movie" }, status: :bad_request
    end
  end

  private

    def rental_params
      params.permit(:movie_id, :customer_id)
    end
end
