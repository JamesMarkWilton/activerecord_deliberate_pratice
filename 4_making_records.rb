require_relative 'setup'
ActiveRecord::Schema.define do
  self.verbose = false

  create_table :cars do |t|
    t.integer :year
    t.integer :make_id
    t.integer :model_id
  end
  create_table :makes do |t|
    t.string  :name
  end
  create_table :models do |t|
    t.string  :name
  end

  # <-- your work goes here
end

class Car < ActiveRecord::Base
  belongs_to :make
  belongs_to :model
end

class Make < ActiveRecord::Base
  has_many :cars
  validates :name, presence: true
end

class Model < ActiveRecord::Base
  has_many :cars
end


# =====  Examples  =====
# -----  new  -----
#   makes the object in memory without saving it to the db
Make.new(name: 'Buick') # => #<Make id: nil, name: "Buick">
Make.count              # => 0

# -----  new_record?  -----
#   true if the object hasn't been saved to the database
#   false otherwise
Make.new(name:     'Buick').new_record?  # => true
Make.create!(name: 'Buick').new_record?  # => false

# -----  persisted?  -----
#   opposite of new_record?
Make.new(name:     'Buick').persisted?  # => false
Make.create!(name: 'Buick').persisted?  # => true

# -----  save  -----
#   saves the object into the database if it can
#   returns true if it saved
#   returns false if it did not save
make = Make.new  # won't save b/c it needs a name
make.save        # => false
make.name = 'Buick'
make.save        # => true


# -----  save!  -----
#   same as save, but explodes when it can't save
#   ideal for tests, where you want your code to blow up so you can fix it
#   but in your controller, you probably don't want it to blow up
#   you probably want to render a form instead, so you would use the normal version
begin
  # won't save b/c it needs a name
  Make.new.save!
rescue => error
  error # => #<ActiveRecord::RecordInvalid: Validation failed: Name can't be blank>
end
Make.new(name: 'Buick').save! # => true

# -----  create  -----
#   makes the record, saves it if it can
#   returns the record
Make.create.new_record?                # => true
Make.create(name: 'Buick').new_record? # => false

# -----  block construction  -----
#   you can give `create` a block
#   and it will allow you to declare other attributes
ford = Make.create do |ford|
  ford.name = 'Ford'
end
ford.name # => "Ford"


# -----  create!  -----
#   same as create, but explodes when it can't save,
#   ideal for tests
begin
  Make.create!
rescue => error
  error # => #<ActiveRecord::RecordInvalid: Validation failed: Name can't be blank>
end
Make.create!(name: 'Buick') # => #<Make id: 7, name: "Buick">


# -----  find_or_create_by  -----
#   queries the database for an existing record if there is one
#   creates a new record if there is not one
Model.where(             name: 'Le Sabre' ).count # => 0
Model.find_or_create_by( name: 'Le Sabre' )
Model.where(             name: 'Le Sabre' ).count # => 1
Model.find_or_create_by( name: 'Le Sabre' )
Model.where(             name: 'Le Sabre' ).count # => 1


# -----  Constructing relationships with an array of records  -----
buick = Make.create! name: 'Buick', cars: [
  Car.new(year: 2000),
  Car.new(year: 2001),
  Car.new(year: 2002),
]
buick.cars
# => #<ActiveRecord::Associations::CollectionProxy [
#     #<Car:0x007fa564941b08 id: 1, year: 2000, make_id: 8, model_id: nil>,
#     #<Car:0x007fa56496b368 id: 2, year: 2001, make_id: 8, model_id: nil>,
#     #<Car:0x007fa56496aeb8 id: 3, year: 2002, make_id: 8, model_id: nil>]>


# -----  Constructing relationships by building on the association  -----
# build will create one in memory
# it knows about the relationship between the two records
cavalier = Model.find_or_create_by name: 'Cavalier'
impala   = Model.find_or_create_by name: 'Impala'

chevy = Make.create! name: 'Chevrolet' do |chevy|
  chevy.cars.build year: 2000, model: cavalier
  chevy.cars.build year: 2001, model: impala
  # Nesting the blocks
  chevy.cars.build do |car|
    car.year  = 2002
    car.model = cavalier
  end
end

chevy.cars.pluck(:year)


# MODELS
#   We need artists that have names,
#   and paintings which have names (validate this) and prices
#   infer the relationship from the names
# <-- your work goes here (don't forget about the migration up top)

class MakingRecords < Minitest::Test
  def test_paintings_have_names
    painting = "??" # <-- your work goes here
    assert_equal 'Mona Lisa', painting.name
    assert_equal 0, Painting.count
  end

  def test_paintings_have_prices
    painting = "??" # <-- your work goes here
    assert_equal 123_456_99, painting.price
    assert_equal 0, Painting.count
  end

  def test_you_can_tell_if_paintings_are_saved
    # keep in mind that you'll need to validate that the name is present
    painting = Painting.new
    painting.save
    is_saved = painting.some_method # <-- your work goes here
    assert_equal false, is_saved

    painting = Painting.new name: 'The Last Supper'
    painting.save
    is_saved = painting.some_method # <-- your work goes here
    assert_equal true, is_saved
  end

  def test_you_can_tell_if_paintings_are_unsaved
    painting = Painting.new
    painting.save
    is_saved = painting.some_method # <-- your work goes here
    assert_equal true, is_saved

    painting = Painting.new name: 'The Last Supper'
    painting.save
    is_saved = painting.some_method # <-- your work goes here
    assert_equal false, is_saved
  end

  def test_create_an_artist_with_3_paintings_using_array_syntax
    artist = '??' # <-- your work goes here
    assert_equal 'Leonardo Da Vinci',    artist.name
    assert_equal 3,                      artist.paintings.count
    assert_equal 'Mona Lisa',            artist.paintings.first.name
    assert_equal 111_111_11,             artist.paintings.first.price
    assert_equal 'The Last Supper',      artist.paintings.second.name
    assert_equal 222_222_22,             artist.paintings.second.price
    assert_equal 'St. John the Baptist', artist.paintings.last.name
    assert_equal 333_333_33,             artist.paintings.last.price
  end

  def test_create_an_artist_with_3_paintings_using_block_syntax
    artist = '??' # <-- your work goes here
    assert_equal 'Leonardo Da Vinci',    artist.name
    assert_equal 3,                      artist.paintings.count
    assert_equal 'Mona Lisa',            artist.paintings.first.name
    assert_equal 111_111_11,             artist.paintings.first.price
    assert_equal 'The Last Supper',      artist.paintings.second.name
    assert_equal 222_222_22,             artist.paintings.second.price
    assert_equal 'St. John the Baptist', artist.paintings.last.name
    assert_equal 333_333_33,             artist.paintings.last.price
  end

  def test_create_a_record_only_once
    Painting.delete_all
    10.times do
      # <-- your work goes here
    end
    assert_equal 1,           Painting.count
    assert_equal 'Mona Lisa', Painting.first.name
    assert_equal 111_222_33,  Painting.first.price
  end
end

