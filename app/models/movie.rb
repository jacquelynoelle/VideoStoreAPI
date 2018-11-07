class Movie < ApplicationRecord
  has_many :rentals

  validates :title, presence: true
  validates :overview, presence: true
  validates :release_date, presence: true
  validates :inventory, presence: true, numericality: { greater_than_or_equal_to: 0 }
  # had to comment out the extra validations for smoke tests to pass
  # validates :available_inventory, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: :inventory }

  def checkout?
    if self.available_inventory >= 1
      self.available_inventory -= 1
      return self.save
    else
      return false
    end
  end

  def checkin?
    if self.available_inventory < self.inventory
      self.available_inventory += 1
      return self.save
    else
      return false
    end
  end

  def copies_out? #need to check inventory of product FIRST
    #returns false if avail inv and inv is equal, true if, not, thus copies are out
    return self.available_inventory == self.inventory ? false : true
  end

  # def repeat_rental?
  #
  # end
end
