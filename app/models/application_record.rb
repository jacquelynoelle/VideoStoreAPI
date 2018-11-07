class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def current_rentals
    return self.rentals.select do |rental|
      rental.checked_out
    end
  end

  def historical_rentals
    return self.rentals.select do |rental|
      !rental.checked_out
    end
  end
end
