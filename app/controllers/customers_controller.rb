class CustomersController < ApplicationController
  def zomg
    render json: { zomg: "it works!" }
  end

  def index
    customers = Customer.all

    customers = sort_and_paginate(customers, customer_params)

    render json: customers.as_json(except: [:address, :city, :state, :created_at, :updated_at]), status: :ok
  end

  def current
    customer = Customer.find_by(id: params[:id].to_i)

    list = customer.current_rentals.map do |rental|
      {
        checkout_date: rental.checkout_date,
        due_date: rental.due_date,
        title: rental.movie.title
      }
    end

    list = sort_and_paginate(list, customer_params)

    render json: list.as_json, status: :ok
  end

  def history
    customer = Customer.find_by(id: params[:id].to_i)

    list = customer.historical_rentals.map do |rental|
      {
        checkout_date: rental.checkout_date,
        due_date: rental.due_date,
        title: rental.movie.title
      }
    end

    list = sort_and_paginate(list, customer_params)

    render json: list.as_json, status: :ok
  end

  private

    def customer_params
      params.permit(:sort, :n, :p)
    end
end
