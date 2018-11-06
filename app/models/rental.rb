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
    checkout_date = Date.today
    due_date = Date.today + 7
    if movie.checkout? && customer.rent_movie?
      return self.save
    else
      return false
    end
  end

  def checkin?
    if movie.checkin? && customer.return_movie?
      return self.save
    else
      return false
    end
  end
end
