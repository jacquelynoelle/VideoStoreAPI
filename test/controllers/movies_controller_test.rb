require "test_helper"

describe MoviesController do
  let(:movie) { movies(:movie1) }

  describe "index" do
    it "is a real working route and returns JSON" do
      # Act
      get movies_path

      # Assert
      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :success
    end

    it "returns an array" do
      # Act
      get movies_path

      # Convert the JSON response into a Hash
      body = JSON.parse(response.body)

      # Assert
      expect(body).must_be_kind_of Array
    end

    it "returns all of the movies" do
      # Act
      get movies_path

      # Convert the JSON response into a Hash
      body = JSON.parse(response.body)

      # Assert
      expect(body.length).must_equal Movie.count
    end

    it "returns movies with exactly the required fields" do
      keys = %w(id release_date title)

      # Act
      get movies_path

      # Convert the JSON response into a Hash
      body = JSON.parse(response.body)

      # Assert that each
      body.each do |mov|
        expect(mov.keys.sort).must_equal keys
        expect(mov.keys.length).must_equal keys.length
      end
    end

    it "can sort movies by title" do

      get movies_path, params: {sort: "title"}

      body = JSON.parse(response.body)

      expect(body.first["title"]).must_equal movies(:movie2)["title"]
      expect(body.last["title"]).must_equal movies(:movie3)["title"]
    end

    it "can sort movies by release_date" do
      get movies_path, params: {sort: "release_date"}

      body = JSON.parse(response.body)

      expect(body.first["title"]).must_equal movies(:movie2)["title"]
      expect(body.last["title"]).must_equal movies(:movie1)["title"]
    end

    it "can sort movies and paginate and return specified page" do
      get movies_path, params: {sort: "release_date", n: 1, p: 3}

      body = JSON.parse(response.body)

      expect(body.count).must_equal 1
      expect(body.first["title"]).must_equal movies(:movie1)["title"]
    end

    it "can return a user-specified number of responses" do
      get movies_path, params: {n: 1}

      body = JSON.parse(response.body)

      expect(body.count).must_equal 1
    end

    it "can return a specified number of responses on specified page" do
      get movies_path, params: {n: 1, p: 2}

      body = JSON.parse(response.body)

      expect(body.count).must_equal 1
      expect(body.first["title"]).must_equal movies(:movie2)["title"]
    end
  end

  describe "show" do
    it "is a real working route and returns JSON" do
      # Act
      get movie_path(movie.id)

      # Assert
      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :success
    end

    it "returns a hash" do
      # Act
      get movie_path(movie.id)

      # Convert the JSON response into a Hash
      body = JSON.parse(response.body)

      # Assert
      expect(body).must_be_kind_of Hash
    end

    it "returns a hash with exactly the required fields" do
      keys = %w(available_inventory inventory overview release_date title)

      # Act
      get movie_path(movie.id)

      # Convert the JSON response into a Hash
      body = JSON.parse(response.body)

      # Assert that each
      expect(body.keys.sort).must_equal keys
      expect(body.keys.length).must_equal keys.length
    end

    it "responds with a 404 message if no movie is found" do
      id = -1
      get movie_path(id)
      must_respond_with :not_found
    end
  end

  describe "create" do
    let(:movie_data) {
      {
        title: "Pirates of the Caribbean",
        overview: "Disney movie",
        release_date: "2004-09-10",
        inventory: 10,
        available_inventory: 10
      }
    }

    it "is a real working route and returns JSON" do
      # Act
      post movies_path, params: movie_data

      # Assert
      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :success
    end

    it "creates a new movie given valid data" do
      expect {
        post movies_path, params: movie_data
      }.must_change "Movie.count", 1

      body = JSON.parse(response.body)
      expect(body).must_be_kind_of Hash
      expect(body).must_include "id"

      movie = Movie.find(body["id"].to_i)

      expect(movie.title).must_equal movie_data[:title]
      must_respond_with :success
    end

    it "returns an error for invalid movie data" do
      # arrange
      movie_data["title"] = nil

      expect {
        post movies_path, params: movie_data
      }.wont_change "Movie.count"

      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Hash
      expect(body).must_include "errors"
      expect(body["errors"]).must_include "title"
      must_respond_with :bad_request
    end
  end
end
