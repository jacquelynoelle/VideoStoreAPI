require "test_helper"

describe CustomersController do
  describe "index" do
    it "is a real working route and returns JSON" do
      # Act
      get customers_path

      # Assert
      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :success
    end

    it "returns an array" do
      # Act
      get customers_path

      # Convert the JSON response into a Hash
      body = JSON.parse(response.body)

      # Assert
      expect(body).must_be_kind_of Array
    end

    it "returns all of the customers" do
      # Act
      get customers_path

      # Convert the JSON response into a Hash
      body = JSON.parse(response.body)

      # Assert
      expect(body.length).must_equal Customer.count
    end

    it "returns customers with exactly the required fields" do
      keys = %w(id movies_checked_out_count name phone postal_code registered_at)

      # Act
      get customers_path

      # Convert the JSON response into a Hash
      body = JSON.parse(response.body)

      # Assert that each
      body.each do |customer|
        expect(customer.keys.sort).must_equal keys
        expect(customer.keys.length).must_equal keys.length
      end
    end

    it "can sort customers" do
      # check name sort
      get customers_path, params: {sort: "name"}

      body = JSON.parse(response.body)

      expect(body.first["name"]).must_equal customers(:customer3)["name"]
      expect(body.last["name"]).must_equal customers(:customer2)["name"]

      get customers_path, params: {sort: "postal_code"}

      body = JSON.parse(response.body)

      # check zip
      expect(body.first["postal_code"]).must_equal customers(:customer2)["postal_code"]
      expect(body.last["postal_code"]).must_equal customers(:customer3)["postal_code"]

      # check reg date
      get customers_path, params: {sort: "registered_at"}

      body = JSON.parse(response.body)

      expect(body.first["registered_at"]).must_equal customers(:customer3)["registered_at"]
      expect(body.last["registered_at"]).must_equal customers(:customer1)["registered_at"]
    end

    it "can sort customers and paginate and return specified page" do
      get customers_path, params: {sort: "name", n: 1, p: 3}

      body = JSON.parse(response.body)

      expect(body.count).must_equal 1
      expect(body.first["name"]).must_equal customers(:customer2)["name"]
    end

    it "can return a user-specified number of responses" do
      get customers_path, params: {n: 1}

      body = JSON.parse(response.body)

      expect(body.count).must_equal 1
    end

    it "can return a specified number of responses on specified page" do
      get customers_path, params: {n: 1, p: 2}

      body = JSON.parse(response.body)

      expect(body.count).must_equal 1
      expect(body.first["name"]).must_equal customers(:customer2)["name"]
    end
  end

  describe "current" do
    it "is a real working route and returns JSON" do
      # Act
      get customer_current_path(Customer.find_by(name: "Jane Doe").id)

      # Assert
      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :success
    end

    it "returns an array of a customer's checked out rentals" do
      get customer_current_path(Customer.find_by(name: "Jane Doe").id)

      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Array
      expect(body.count).must_equal 1

      expect(body.first["title"]).must_equal movies(:movie2)["title"]

      movie_id = Movie.find_by(title: body.first["title"]).id

      expect(Rental.find_by(movie_id: movie_id).checked_out).must_equal true
    end

    it "returns an empty array if a customer has no checked out rentals" do
      rentals(:customer1checkedout).checked_out = false
      rentals(:customer1checkedout).save

      get customer_current_path(Customer.find_by(name: "Jane Doe").id)

      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Array
      expect(body.empty?).must_equal true
    end
  end

  describe "history" do
    it "is a real working route and returns JSON" do
      # Act
      get customer_history_path(Customer.find_by(name: "Jane Doe").id)

      # Assert
      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :success
    end

    it "returns an array of a customer's checked in rentals" do
      get customer_history_path(Customer.find_by(name: "Jane Doe").id)

      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Array
      expect(body.count).must_equal 1
      
      expect(body.first["title"]).must_equal movies(:movie1)["title"]

      movie_id = Movie.find_by(title: body.first["title"]).id

      expect(Rental.find_by(movie_id: movie_id).checked_out).must_equal false
    end

    it "returns an empty array if a customer has no checked in rentals" do
      rentals(:rental1).checked_out = true
      rentals(:rental1).save

      get customer_history_path(Customer.find_by(name: "Jane Doe").id)

      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Array
      expect(body.empty?).must_equal true
    end

    it "can sort customer history" do
      movie = movies(:movie1)
      customer = Customer.find_by(name: "Jane Doe")
      rental = movie.rentals.find_by(customer_id: customer.id)

      # check title sort
      get customer_history_path(customer.id), params: {sort: "title"}

      body = JSON.parse(response.body)

      expect(body.first["title"]).must_equal (movie.title)

      # checkout date sort
      get customer_history_path(customer.id), params: {sort: "checkout_date"}

      body = JSON.parse(response.body)

      expect(Date.parse(body.first["checkout_date"])).must_equal Date.parse(rental.checkout_date.to_s)
    end

    it "can sort customer history and paginate and return specified page" do
      customer = Customer.find_by(name: "Jane Doe")

      get customer_history_path(customer.id), params: {sort: "title", n: 1, p: 3}

      body = JSON.parse(response.body)

      expect(body.count).must_equal 0
      expect(body.empty?).must_equal true
    end
  end
end
