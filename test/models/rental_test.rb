require "test_helper"

describe Rental do
  let(:rental) { rentals(:rental1) }

  it "must be valid" do
    value(rental).must_be :valid?
  end

  describe "relations" do
    it "belongs to a customer" do
      expect(rental).must_respond_to :customer
      expect(rental.customer).must_be_kind_of Customer
    end

    it "belongs to a movie" do
      expect(rental).must_respond_to :movie
      expect(rental.movie).must_be_kind_of Movie
    end
  end

  describe "validations" do
    it "must have a checkout_date" do
      valid = rental.valid?
      expect(valid).must_equal true

      rental.checkout_date = nil
      rental.save
      valid = rental.valid?
      expect(valid).must_equal false
    end

    it "must have a due_date" do
      valid = rental.valid?
      expect(valid).must_equal true

      rental.due_date = nil
      rental.save
      valid = rental.valid?
      expect(valid).must_equal false
    end

    it "must have a due_date that is after the checkout_date" do
      valid = rental.valid?
      expect(valid).must_equal true

      rental.due_date = rental.checkout_date - 1
      rental.save
      valid = rental.valid?
      expect(valid).must_equal false
    end
  end

  describe "checkout?" do
    it "must set the checkout_date to today" do
      new_rental = Rental.new(customer_id: Customer.first.id, movie_id: Movie.first.id)
      expect(new_rental.checkout_date).must_be_nil
      expect(new_rental.checkout?).must_equal true
      expect(new_rental.checkout_date).must_equal Date.today
    end

    it "must set the due_date to one week from today" do
      new_rental = Rental.new(customer_id: Customer.first.id, movie_id: Movie.first.id)
      expect(new_rental.due_date).must_be_nil
      expect(new_rental.checkout?).must_equal true
      expect(new_rental.due_date).must_equal Date.today + 7
    end

    it "returns false when given bad inputs" do
      invalid_Rental = Rental.new(customer_id: -1, movie_id: 1)
      expect(invalid_Rental.checkout?).must_equal false
    end
  end

  describe "checkin?" do
    it "returns true when given valid inputs" do
      expect(rental.checkin?).must_equal true
    end

    it "returns false when given bad inputs" do
      invalid_rental = Rental.new(customer_id: -1, movie_id: 1, checkout_date: Date.today, due_date: Date.today + 7)
      expect(invalid_rental.checkin?).must_equal false
    end
  end
end
