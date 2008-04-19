require 'test/unit'
require 'array'
class ArrayTest < Test::Unit::TestCase
  def test_should_sum_up_an_array_without_a_block
    foo = [1,2,3]
    assert_equal 6, foo.sum
  end

  def test_should_sum_up_hash_with_block_usage
    # sum = 15
    foo = {:a_key => 1, :another_key => 7, :more_of_a_key => 7}
    assert_equal 15, foo.keys.sum{|i| foo[i]}
  end
end
