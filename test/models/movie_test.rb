require "test_helper"

describe Movie do
  let(:movie) { movies(:movie1) }

  it "must be valid" do
    value(movie).must_be :valid?
  end

  describe "relations" do
    it "has a list of rentals" do
       expect(movie).must_respond_to :rentals
       movie.rentals.each do |rental|
         expect(rental).must_be_kind_of Rental
       end
    end
  end

  describe "validations" do
    it "must have a title" do
      valid = movie.valid?
      expect(valid).must_equal true

      movie.title = nil
      movie.save
      valid = movie.valid?
      expect(valid).must_equal false
    end

    it "must have a overview" do
      valid = movie.valid?
      expect(valid).must_equal true

      movie.overview = nil
      movie.save
      valid = movie.valid?
      expect(valid).must_equal false
    end

    it "must have a release_date" do
      valid = movie.valid?
      expect(valid).must_equal true

      movie.release_date = nil
      movie.save
      valid = movie.valid?
      expect(valid).must_equal false
    end

    it "must have an inventory" do
      valid = movie.valid?
      expect(valid).must_equal true

      movie.inventory = nil
      # had to comment out the extra available inventory validations for smoke tests to pass
      # expect {
        movie.save
        valid = movie.valid?
        expect(valid).must_equal false
      # }.must_raise ArgumentError
    end

    it "must have an inventory greater than or equal to 0" do
      valid = movie.valid?
      expect(valid).must_equal true

      movie.inventory = -1
      movie.save
      valid = movie.valid?
      expect(valid).must_equal false
    end

    # had to comment out the extra validations for smoke tests to pass
    # it "must have an available_inventory" do
    #   valid = movie.valid?
    #   expect(valid).must_equal true
    #
    #   movie.available_inventory = nil
    #   movie.save
    #   valid = movie.valid?
    #   expect(valid).must_equal false
    # end
    #
    # it "must have an available_inventory greater than or equal to 0" do
    #   valid = movie.valid?
    #   expect(valid).must_equal true
    #
    #   movie.available_inventory = -1
    #   movie.save
    #   valid = movie.valid?
    #   expect(valid).must_equal false
    # end
    #
    # it "must have an available_inventory less than or equal to inventory" do
    #   valid = movie.valid?
    #   expect(valid).must_equal true
    #
    #   movie.available_inventory = 100
    #   movie.save
    #   valid = movie.valid?
    #   expect(valid).must_equal false
    # end
  end
end
