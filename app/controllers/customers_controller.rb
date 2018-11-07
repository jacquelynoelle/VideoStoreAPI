class CustomersController < ApplicationController
  def zomg
    render json: { zomg: "it works!" }
  end

  def index
    customers = Customer.all

    if customer_params[:sort]
      customers = customers.order(customer_params[:sort] => :asc)
    end

    if customer_params[:n] || customer_params[:p]
      query_check
      customers = customers.paginate(page: customer_params[:p], per_page: customer_params[:n])
    end

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

    render json: list.as_json, status: :ok
  end

  private

    def customer_params
      params.permit(:sort, :n, :p)
    end

    def query_check
      if customer_params[:n] && !customer_params[:p]
        return customer_params[:p] = 1
      end

      if customer_params[:p] && !customer_params[:n]
        return customer_params[:n] = 10
      end
    end
end
