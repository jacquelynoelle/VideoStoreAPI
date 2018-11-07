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

    list = sort_list(list)
    list = paginate_list(list)

    render json: list.as_json, status: :ok
  end

  private

    def rental_params
      params.permit(:movie_id, :customer_id, :id, :checkout_date, :due_date, :sort, :n, :p) #sort by n (number) or p (page) or both
    end

    def sort_list(list)
      if rental_params[:sort]
        return list.order(rental_params[:sort] => :asc)
      else
        return list
      end
    end

    def paginate_list(list)
      if rental_params[:n] || rental_params[:p]
        if rental_params[:n] && !rental_params[:p]
          rental_params[:p] = 1
        end

        if rental_params[:p] && !rental_params[:n]
          rental_params[:n] = 10
        end

        return list.paginate(page: rental_params[:p], per_page: rental_params[:n])
      else
        return list
      end
    end
end
