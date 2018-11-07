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
      expect {
        expect(customer.rent_movie?).must_equal true
      }.must_change 'customer.movies_checked_out_count', 1
    end
  end

  describe "return_movie?" do
    it "must subtract 1 from movies_checked_out_count" do
      expect {
        expect(customer.return_movie?).must_equal true
      }.must_change 'customer.movies_checked_out_count', -1
    end

    it "wont change movies_checked_out_count if customer has no current rentals" do
      expect {
        expect(customer.return_movie?).must_equal true
      }.must_change 'customer.movies_checked_out_count', -1

      expect {
        expect(customer.return_movie?).must_equal false
      }.wont_change 'customer.movies_checked_out_count'
    end
  end

  describe "current_rentals" do
    it "returns an array of a customer's checked out rentals" do
      currents = Customer.find_by(name: "Jane Doe").current_rentals

      expect(currents).must_be_kind_of Array
      expect(currents.count).must_equal 1
      expect(currents.first["movie_id"]).must_equal movies(:movie2)["id"]
      expect(currents.first["checked_out"]).must_equal true
    end

    it "returns an empty array if a customer has no checked out rentals" do
      rentals(:customer1checkedout).checked_out = false
      rentals(:customer1checkedout).save

      expect(Customer.find_by(name: "Jane Doe").current_rentals).must_be_kind_of Array
      expect(Customer.find_by(name: "Jane Doe").current_rentals.empty?).must_equal true
    end
  end

  describe "historical_rentals" do
    it "returns an array of a customer's checked in rentals" do
      currents = Customer.find_by(name: "Jane Doe").historical_rentals

      expect(currents).must_be_kind_of Array
      expect(currents.count).must_equal 1
      expect(currents.first["movie_id"]).must_equal movies(:movie1)["id"]
      expect(currents.first["checked_out"]).must_equal false
    end

    it "returns an empty array if a customer has no checked in rentals" do
      rentals(:rental1).checked_out = true
      rentals(:rental1).save

      expect(Customer.find_by(name: "Jane Doe").historical_rentals).must_be_kind_of Array
      expect(Customer.find_by(name: "Jane Doe").historical_rentals.empty?).must_equal true
    end
  end
end
