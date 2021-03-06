class CustomersController < ApplicationController
  def zomg
    render json: { zomg: "it works!" }
  end

  def index
    customers = Customer.all

    @customers = sort_and_paginate(customers, customer_params)

    render :index, status: :ok
  end

  private

    def customer_params
      params.permit(:sort, :n, :p)
    end

    def rentals_list(criteria)
      customer = Customer.find_by(id: params[:id].to_i)

      list = customer.send(criteria)

      @list = sort_and_paginate(list, customer_params)

      render :rentals, status: :ok
    end
end
