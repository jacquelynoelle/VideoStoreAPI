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
      expect(body).must_include "id"
      expect(body).must_include "checkout_date"
      expect(body).must_include "customer_id"
      expect(body).must_include "due_date"
      expect(body).must_include "movie_id"

      rental = Rental.find(body["id"].to_i)

      expect(rental.customer_id).must_equal rental_data[:customer_id]
      expect(rental.movie_id).must_equal rental_data[:movie_id]
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

  # def checkin
  #   rental = Rental.find_by(movie_id: params[:movie_id], customer_id: params[:customer_id])
  #
  #   if rental.nil?
  #     render json: { message: "Rental not found" }, status: :not_found
  #   elsif rental.checkin?
  #     render json: rental.as_json(except: [:created_at, :updated_at]), status: :ok
  #   else
  #     render json: { message: "Could not check-in movie" }, status: :bad_request
  #   end
  # end
end
