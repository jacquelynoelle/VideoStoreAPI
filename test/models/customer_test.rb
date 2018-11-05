require "test_helper"

describe Customer do
  let(:customer) { Customer.new }

  it "must be valid" do
    value(customer).must_be :valid?
  end

  describe "relations" do
    it "has a list of rentals" do
       customer.must_respond_to :rentals
       customer.rentals.each do |rental|
         rental.must_be_kind_of Rental
       end
    end
  end

  describe "validations" do
    it "allows the three valid categories" do
      valid_categories = ['album', 'book', 'movie']
      valid_categories.each do |category|
        work = Work.new(title: "test", category: category)
        work.valid?.must_equal true
      end
    end

    it "fixes almost-valid categories" do
      categories = ['Album', 'albums', 'ALBUMS', 'books', 'mOvIeS']
      categories.each do |category|
        work = Work.new(title: "test", category: category)
        work.valid?.must_equal true
        work.category.must_equal category.singularize.downcase
      end
    end

    it "rejects invalid categories" do
      invalid_categories = ['cat', 'dog', 'phd thesis', 1337, nil]
      invalid_categories.each do |category|
        work = Work.new(title: "test", category: category)
        work.valid?.must_equal false
        work.errors.messages.must_include :category
      end
    end

    it "requires a title" do
      work = Work.new(category: 'ablum')
      work.valid?.must_equal false
      work.errors.messages.must_include :title
    end

    it "requires unique names w/in categories" do
      category = 'album'
      title = 'test title'
      work1 = Work.new(title: title, category: category)
      work1.save!

      work2 = Work.new(title: title, category: category)
      work2.valid?.must_equal false
      work2.errors.messages.must_include :title
    end

    it "does not require a unique name if the category is different" do
      title = 'test title'
      work1 = Work.new(title: title, category: 'album')
      work1.save!

      work2 = Work.new(title: title, category: 'book')
      work2.valid?.must_equal true
    end
  end
end
