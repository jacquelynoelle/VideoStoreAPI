require 'date'

class RentalsController < ApplicationController
  def checkout
    rental = Rental.new(rental_params)
    rental.checkout_date = Date.today
    rental.due_date = Date.today + 7

    if rental.movie.checkout && rental.save
      render json: { ok: true,
        id: rental[:id].as_json
      }, status: :ok
    else
      render json: { ok: false,
        errors: rental.errors.messages
      }, status: :bad_request
    end
  end

  def checkin
    rental = Rental.find_by(movie_id: params[:movie_id], customer_id: params[:customer_id])

    if rental.nil?
      render json: { ok: false, message: "Rental not found" }, status: :not_found
    elsif rental.movie.checkin
      render json: {
        ok: true,
        rental: movie.as_json(except: [:created_at, :updated_at])
      }, status: :ok
    else
      render json: { ok: false, message: "Could not check-in movie" }, status: :bad_request
    end
  end

  private

    def rental_params
      params.require(:rental).permit(:movie_id, :customer_id)
    end
end
