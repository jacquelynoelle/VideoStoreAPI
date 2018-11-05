class CustomersController < ApplicationController
  def zomg
    render json: { zomg: "it works!" }
  end

  def index
    customers = Customer.all
    render json: customers.as_json(except: [:created_at, :updated_at]), status: :ok
  end
end
