object @list

attributes :customer_id, :checkout_date, :due_date

node(:name) { |rental| rental.customer["name"] }

node(:postal_code) { |rental| rental.customer["postal_code"]}
