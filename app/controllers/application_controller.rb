class ApplicationController < ActionController::API
  def current
    rentals_list(:current_rentals)
  end

  def history
    rentals_list(:historical_rentals)
  end

  private
    def sort_and_paginate(list, params)
      list = sort_list(list, params)
      list = paginate_list(list, params)
      return list
    end

    def sort_list(list, params)
      if params[:sort]
        return list.sort_by{ |item| item[params[:sort]] }
      else
        return list
      end
    end

    def paginate_list(list, params)
      if params[:n] || params[:p]
        if params[:n] && !params[:p]
          params[:p] = 1
        end

        if params[:p] && !params[:n]
          params[:n] = 10
        end

        if params[:p].to_i > 0
          return list.paginate(page: params[:p].to_i, per_page: params[:n].to_i)
        else
          return []
        end
      else
        return list
      end
    end
end
