require "test_helper"

describe Customer do
  let(:customer) { customers(:customer1) }

  it "must be valid" do
    value(customer).must_be :valid?
  end

  describe "relations" do
    it "has a list of rentals" do
       expect(customer).must_respond_to :rentals
       customer.rentals.each do |rental|
         expect(rental).must_be_kind_of Rental
       end
    end
  end

  describe "validations" do
    it "must have a name" do
      valid = customer.valid?
      expect(valid).must_equal true

      customer.name = nil
      customer.save
      valid = customer.valid?
      expect(valid).must_equal false
    end

    it "must have a registered_at" do
      valid = customer.valid?
      expect(valid).must_equal true

      customer.registered_at = nil
      customer.save
      valid = customer.valid?
      expect(valid).must_equal false
    end

    it "must have a address" do
      valid = customer.valid?
      expect(valid).must_equal true

      customer.address = nil
      customer.save
      valid = customer.valid?
      expect(valid).must_equal false
    end

    it "must have a city" do
      valid = customer.valid?
      expect(valid).must_equal true

      customer.city = nil
      customer.save
      valid = customer.valid?
      expect(valid).must_equal false
    end

    it "must have a state" do
      valid = customer.valid?
      expect(valid).must_equal true

      customer.state = nil
      customer.save
      valid = customer.valid?
      expect(valid).must_equal false
    end

    it "must have a postal_code" do
      valid = customer.valid?
      expect(valid).must_equal true

      customer.postal_code = nil
      customer.save
      valid = customer.valid?
      expect(valid).must_equal false
    end

    it "must have a phone" do
      valid = customer.valid?
      expect(valid).must_equal true

      customer.phone = nil
      customer.save
      valid = customer.valid?
      expect(valid).must_equal false
    end

    it "must have a movies_checked_out_count" do
      valid = customer.valid?
      expect(valid).must_equal true

      customer.movies_checked_out_count = nil
      customer.save
      valid = customer.valid?
      expect(valid).must_equal false
    end

    it "must have an movies_checked_out_count greater than or equal to 0" do
      valid = customer.valid?
      expect(valid).must_equal true

      customer.movies_checked_out_count = -1
      customer.save
      valid = customer.valid?
      expect(valid).must_equal false
    end
  end

  describe "rent_movie?" do
    it "must add 1 to movies_checked_out_count" do
      expect(customer.movies_checked_out_count).must_equal 1
      expect(customer.rent_movie?).must_equal true
      expect(customer.movies_checked_out_count).must_equal 2
    end
  end

  describe "return_movie?" do
    it "must subtract 1 from movies_checked_out_count" do
      expect(customer.movies_checked_out_count).must_equal 1
      expect(customer.return_movie?).must_equal true
      expect(customer.movies_checked_out_count).must_equal 0
    end

    it "wont change movies_checked_out_count if customer has no current rentals" do
      expect(customer.movies_checked_out_count).must_equal 1
      expect(customer.return_movie?).must_equal true
      expect(customer.movies_checked_out_count).must_equal 0
      expect{
        customer.return_movie?
      }.wont_change 'customer.movies_checked_out_count'
      expect(customer.return_movie?).must_equal false
    end
  end
end
