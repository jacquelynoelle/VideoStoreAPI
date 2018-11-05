class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :movie

  validates :checkout_date, presence: true
  validates :due_date, presence: true
  validate :due_date_after_checkout_date?

  def due_date_after_checkout_date?
    if due_date && checkout_date && due_date < checkout_date
      errors.add :due_date, "must be after checkout date"
    end
  end
end
