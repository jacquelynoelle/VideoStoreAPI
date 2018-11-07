collection @list

attributes :checkout_date, :due_date

node(:title) { |rental| rental.movie["title"] }
