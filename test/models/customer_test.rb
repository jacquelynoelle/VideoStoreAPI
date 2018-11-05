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
  end
end
