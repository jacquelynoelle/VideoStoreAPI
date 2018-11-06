class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :movie

  validates :checkout_date, presence: true
  validates :due_date, presence: true
  validate :one_week_rental?

  def one_week_rental?
    if due_date && checkout_date && (due_date - checkout_date != 7)
      errors.add :due_date, "must be one week after checkout date"
    end
  end

  def checkout?
    return self.save if customer.nil? || movie.nil?

    self.checkout_date = Date.today
    self.due_date = Date.today + 7

    if movie.checkout? && customer.rent_movie?
      return self.save
    else
      return false
    end
  end

  def checkin?
    return self.save if customer.nil? || movie.nil? #return t or f if either is nil

    if movie.checkin? && customer.return_movie? #if can checkin && can return movie
      return self.save
    else
      return false
    end
  end
end
