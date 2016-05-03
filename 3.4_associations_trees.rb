# Diagram: https://gist.github.com/JoshCheek/e60015c983bbe842cffeb02b75452937
require_relative 'setup'
ActiveRecord::Schema.define do
  self.verbose = false

  # MIGRATIONS
  # <-- your work goes here
end


# MODELS
# <-- your work goes here

# FIX THE INFLECTION
ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'clothing', 'clothes' # this one is an example
  # <-- your work goes here
end



# TESTS
class TreesTest < Minitest::Test
  def test_leaves_know_whether_they_are_diseased
    assert_equal true,  Leaf.new(diseased: true).diseased?
    assert_equal false, Leaf.new(diseased: false).diseased?
  end

  def test_diseased_defaults_to_false
    assert_equal false, Leaf.new.diseased?
  end

  def test_leaves_belong_to_a_tree
    tree1 = Tree.new
    tree2 = Tree.new
    leaf1 = Leaf.new tree: tree1
    leaf2 = Leaf.new tree: tree2
    assert_equal tree1, leaf1.tree
    assert_equal tree2, leaf2.tree
  end

  def test_trees_have_leaves
    tree = Tree.create! leaves: [Leaf.new, Leaf.new]
    assert_equal 2, tree.leaves.count
  end
end

