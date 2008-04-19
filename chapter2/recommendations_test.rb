require 'yaml'
require 'recommendations'
require 'test/unit'
class RecommendationsTest < Test::Unit::TestCase
  
  # german book: page 13, bottom
  # INFO: Both the code and the result of the original python version from the book are
  # broken, so don't expect the sim_distance function to return the result stated in the book.
  
  def test_similarity_score_euclidian_distance
    prefs = YAML.load_file('recommendations.yml')
    assert_in_delta 0.294298, sim_distance(prefs, 'Lisa Rose', 'Gene Seymour'), 0.00001
  end

  # german book: page 16, middle
  def test_similarity_score_pearson_coefficient
    prefs = YAML.load_file('recommendations.yml')
    assert_in_delta 0.396059, sim_pearson(prefs, 'Lisa Rose', 'Gene Seymour'), 0.00001
  end
    
end