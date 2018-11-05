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
end
