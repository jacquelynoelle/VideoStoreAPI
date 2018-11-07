require "test_helper"

describe RentalsController do
  describe "checkout" do
    let (:rental_data) {
      {
        movie_id: Movie.first.id,
        customer_id: Customer.first.id
      }
    }

    it "is a real working route and returns JSON" do
      # Act
      post rental_checkout_path, params: rental_data

      # Assert
      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :success
    end

    it "creates a new rental given valid data" do
      expect {
        post rental_checkout_path, params: rental_data
      }.must_change "Rental.count", 1

      body = JSON.parse(response.body)
      expect(body).must_be_kind_of Hash
      expect(body).must_include "checkout_date"
      expect(body).must_include "customer_id"
      expect(body).must_include "due_date"
      expect(body).must_include "movie_id"
      expect(body).must_include "checked_out"

      expect(body["customer_id"]).must_equal rental_data[:customer_id]
      expect(body["movie_id"]).must_equal rental_data[:movie_id]
      expect(body["checked_out"]).must_equal true
      must_respond_with :success
    end

    it "returns an error for invalid rental data" do
      # arrange
      rental_data["movie_id"] = nil

      expect {
        post rental_checkout_path, params: rental_data
      }.wont_change "Rental.count"

      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Hash
      expect(body).must_include "errors"
      expect(body["errors"]).must_include "movie"
      must_respond_with :bad_request
    end
  end

  describe "checkin" do
    let (:rental_data) {
      {
        customer_id: rentals(:rental1).customer.id,
        movie_id: rentals(:rental1).movie.id,
      }
    }

    it "returns rental data with valid input" do
      expect {
        post rental_checkin_path, params: rental_data
      }.wont_change "Rental.count"

      must_respond_with :ok

      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Hash
      expect(body).must_include "checkout_date"
      expect(body).must_include "customer_id"
      expect(body).must_include "due_date"
      expect(body).must_include "movie_id"
      expect(body).must_include "checked_out"

      expect(body["customer_id"]).must_equal rental_data[:customer_id]
      expect(body["movie_id"]).must_equal rental_data[:movie_id]
      expect(body["checked_out"]).must_equal false
    end

    it "renders not found if rental not found" do
      rental_data["movie_id"] = nil

      post rental_checkin_path, params: rental_data

      body = JSON.parse(response.body)

      must_respond_with :not_found

      expect(body["message"]).must_equal "Rental not found"
    end

    it "errrors if invalid data is received" do
      post rental_checkin_path, params: rental_data

      must_respond_with :ok

      3.times do
        post rental_checkin_path, params: rental_data
      end

      body = JSON.parse(response.body)

      expect(body["message"]).must_equal "Could not check-in movie"

      must_respond_with :bad_request
    end
  end

  describe "overdue" do
    it "returns a list of overdue titles" do

      get overdues_path

      body = JSON.parse(response.body)

      expect(body.count).must_equal 1
      expect(body[0]["title"]).must_equal movies(:movie2).title
    end

    it "returns an empty array if no overdue titles" do
      rentals(:overdue_rental).checked_out = false
      rentals(:overdue_rental).save

      get overdues_path

      body = JSON.parse(response.body)

      expect(body.empty?).must_equal true
    end

    it "can sort overdue movies and paginate and return specified page" do
      get overdues_path, params: {sort: "title", n: 1, p: 2}

      body = JSON.parse(response.body)

      expect(body.count).must_equal 0
      expect(body.empty?).must_equal true
    end
  end
end
