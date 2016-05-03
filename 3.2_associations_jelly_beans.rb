require_relative 'setup'
ActiveRecord::Schema.define do
  self.verbose = false

  # MIGRATIONS
  create_table :jelly_beans do |t|
    t.string :color, default: "orange"
    t.integer :jar_id
  end

  create_table :jars do |t|
  end
end

# MODELS
class JellyBean < ActiveRecord::Base
  belongs_to :jar
end

class Jar < ActiveRecord::Base
  has_many :jelly_beans
end


# TESTS
class JellyBeansTest < Minitest::Test
  def test_jelly_beans_have_a_color
    bean = JellyBean.new(color: 'black')
    assert_equal 'black', bean.color
  end

  def test_jelly_beans_are_orange_by_default
    assert_equal 'orange', JellyBean.new.color
  end

  def test_jelly_beans_belong_to_a_jar
    jar1 = Jar.create! jelly_beans: [JellyBean.new(color: 'blue')]
    jar2 = Jar.create! jelly_beans: [JellyBean.new(color: 'green')]
    assert_equal jar1, JellyBean.find_by(color: 'blue').jar
    assert_equal jar2, JellyBean.find_by(color: 'green').jar
  end

  def test_jars_have_jelly_beans
    jar = Jar.create! jelly_beans: [
      JellyBean.new(color: 'blue'),
      JellyBean.new(color: 'green')
    ]
    assert_equal ['blue', 'green'], jar.jelly_beans.pluck(:color)
  end
end
