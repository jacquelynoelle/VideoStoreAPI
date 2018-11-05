Rails.application.routes.draw do
  get 'movies/index'
  get 'movies/show'
  get 'movies/create'
  get 'customers/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/zomg", to: "customers#zomg", as: "zomg"
  
  get "/customers", to: "customers#index", as: "customers"

  get "/movies", to: "movies#index", as: "movies"
  get "/movie/:id", to: "movies#show", as: "movie"
  post "/movies", to: "movies#create"

  post "/rentals/check-out", to: "movies#checkout", as: "movie_checkout"
  post "/rentals/check-in", to: "movies#checkin", as: "movie_checkin"
end


=begin

`GET /customers`
List all customers

Fields to return:
- `id`
- `name`
- `registered_at`
- `postal_code`
- `phone`
- `movies_checked_out_count`
 - This will be 0 unless you've completed optional requirements

#### `GET /movies`
List all movies

Fields to return:
- `id`
- `title`
- `release_date`

#### `GET /movies/:id`
Look a movie up by `id`

URI parameters:
- `id`: Movie identifier

Fields to return:
- `title`
- `overview`
- `release_date`
- `inventory` (total)
- `available_inventory` (not currently checked-out to a customer)
 - This will be the same as `inventory` unless you've completed the optional endpoints.

#### `POST /movies`
Create a new movie in the video store inventory.

Upon success, this request should return the `id` of the movie created.

Request body:

| Field         | Datatype            | Description
|---------------|---------------------|------------
| `title` | string             | Title of the movie
| `overview` | string | Descriptive summary of the movie
| `release_date` | string `YYYY-MM-DD` | Date the movie was released
| `inventory` | integer | Quantity available in the video store

### Wave 3: Rentals

Wave 2 focused on working with customers and movies. With these endpoints you can extend the functionality of your API to allow managing the rental process.

#### `POST /rentals/check-out`
Check out one of the movie's inventory to the customer. The rental's check-out date should be set to today, and the due date should be set to a week from today.

**Note:** Some of the fields from wave 2 should now have interesting values. Good thing you wrote tests for them, right... right?

Request body:

| Field         | Datatype            | Description
|---------------|---------------------|------------
| `customer_id` | integer             | ID of the customer checking out this film
| `movie_id`    | integer | ID of the movie to be checked out

#### `POST /rentals/check-in`
Check in one of a customer's rentals

Request body:

| Field         | Datatype | Description
|---------------|----------|------------
| `customer_id` | integer  | ID of the customer checking in this film
| `movie_id`    | integer | ID of the movie to be checked in

=end
