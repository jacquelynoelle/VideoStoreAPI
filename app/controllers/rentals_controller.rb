require 'date'

class RentalsController < ApplicationController

  def checkout
    rental = Rental.new(rental_params)

    if rental.checkout?
      render json: rental.as_json(except: [:id, :created_at, :updated_at]), status: :ok
    else
      render json: { errors: rental.errors.messages }, status: :bad_request
    end
  end

  def checkin
    rentals = Rental.all.select do |rental|
      rental.movie_id == params[:movie_id].to_i && rental.customer_id == params[:customer_id].to_i
    end

    if rentals.length >= 1
      rental = rentals.sort_by { |rental| rental.due_date }.first
    else
      rental = nil
    end

    if rental.nil?
      render json: { message: "Rental not found" }, status: :not_found
    elsif rental.checkin?
      render json: rental.as_json(except: [:id, :created_at, :updated_at]), status: :ok
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
