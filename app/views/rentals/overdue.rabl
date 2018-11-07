collection @overdues

attributes :movie_id, :customer_id, :checkout_date, :due_date

node(:title) { |o| o.movie["title"] }

node(:name) { |o| o.customer["name"] }

node(:postal_code) { |o| o.customer["postal_code"] }
