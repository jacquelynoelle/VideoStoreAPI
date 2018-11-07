Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/zomg", to: "customers#zomg", as: "zomg"

  get "/customers", to: "customers#index", as: "customers"
  get "/customers/:id/current", to: "customers#current", as: "customer_current"
  get "/customers/:id/history", to: "customers#history", as: "customer_history"

  get "/movies", to: "movies#index", as: "movies"
  get "/movies/:id", to: "movies#show", as: "movie"
  get "/movies/:id/current", to: "movies#current", as: "movies_out"
  get "/movies/:id/history", to: "movies#history", as: "rental_history"
  post "/movies", to: "movies#create"

  get "/rentals/overdue", to: "rentals#overdue", as: "overdues"
  post "/rentals/check-out", to: "rentals#checkout", as: "rental_checkout"
  post "/rentals/check-in", to: "rentals#checkin", as: "rental_checkin"
end
