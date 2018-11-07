class CustomersController < ApplicationController
  def zomg
    render json: { zomg: "it works!" }
  end

  def index
    customers = Customer.all

    customers = sort_list(customers)
    customers = paginate_list(customers)

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

    list = sort_list(list)
    list = paginate_list(list)

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

    list = sort_list(list)
    list = paginate_list(list)

    render json: list.as_json, status: :ok
  end

  private

    def customer_params
      params.permit(:sort, :n, :p)
    end

    def sort_list(list)
      if customer_params[:sort]
        return list.order(customer_params[:sort] => :asc)
      else
        return list
      end
    end

    def paginate_list(list)
      if customer_params[:n] || customer_params[:p]
        if customer_params[:n] && !customer_params[:p]
          customer_params[:p] = 1
        end

        if customer_params[:p] && !customer_params[:n]
          customer_params[:n] = 10
        end

        return list.paginate(page: customer_params[:p], per_page: customer_params[:n])
      else
        return list
      end
    end
end
