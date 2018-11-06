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
    rental = Rental.find_by(id: params[:id].to_i)

    if rental.nil?
      render json: { message: "Rental not found" }, status: :not_found
    elsif rental.checkin?
      render json: rental.as_json(except: [:created_at, :updated_at]), status: :ok
    else
      render json: { message: "Could not check-in movie" }, status: :bad_request
    end
  end

  def overdue #an array with hashess
    rentals = Rental.all

    overdues = rentals.select do |rental|
      rental.overdue?
    end

    list = overdues.map! do |overdue|
      { movie_id: overdue.movie_id,
      customer_id: overdue.customer_id,
      checkout_date: overdue.checkout_date,
      due_date: overdue.due_date,
      title: overdue.movie.title,
      name: overdue.customer.name,
      postal_code: overdue.customer.postal_code }
    end

    render json: list.as_json, status: :ok
  end

  private

    def rental_params
      params.permit(:movie_id, :customer_id, :id, :checkout_date, :due_date, :sort, :n, :p) #sort by n (number) or p (page) or both
    end
end
