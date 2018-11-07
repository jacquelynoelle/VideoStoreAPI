class RentalsController < ApplicationController
  def checkout
    @rental = Rental.new(rental_params)

    if @rental.checkout?
      render :show, status: :ok
    else
      render json: { errors: @rental.errors.messages }, status: :bad_request
    end
  end

  def checkin
    rentals = Rental.all.select do |rental|
      rental.movie_id == params[:movie_id].to_i && rental.customer_id == params[:customer_id].to_i
    end

    # check-in the oldest rental
    if rentals.length >= 1
      @rental = rentals.sort_by { |rental| rental.due_date }.first
    else
      @rental = nil
    end

    if @rental.nil?
      render json: { message: "Rental not found" }, status: :not_found
    elsif @rental.checkin?
      render :show, status: :ok
    else
      render json: { message: "Could not check-in movie" }, status: :bad_request
    end
  end

  def overdue
    rentals = Rental.all

    overdues = rentals.select do |rental|
      rental.overdue?
    end

    @overdues = sort_and_paginate(overdues, rental_params)

    render :overdue, status: :ok
  end

  private

    def rental_params
      params.permit(:movie_id, :customer_id, :id, :checkout_date, :due_date, :sort, :n, :p)
    end
end
