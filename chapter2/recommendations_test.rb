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
  
  #german book: page 17, bottom
  def test_top_matches_with_distance
    prefs = YAML.load_file('recommendations.yml')
    tm = top_matches(prefs, 'Toby', 3)
    assert_equal 3, tm.size
    expected_result = [[0.991240, 'Lisa Rose'], [0.924473, 'Mick LaSalle'], [0.893405, 'Claudia Puig']]
    tm.each_with_index do |match, i|
      assert_equal expected_result[i].last, match.last
      assert_in_delta expected_result[i].first, match.first, 0.00001
    end
  end

  def test_top_matches_with_distance_with_other_block
    prefs = YAML.load_file('recommendations.yml')
    tm = top_matches(prefs, 'Toby', 3) do |prefs, person, other|
      sim_distance(prefs, person, other)
    end
    assert_equal 3, tm.size
  end
  #german book: page 20, top
  def test_get_recommendations
    prefs = YAML.load_file('recommendations.yml')
    recommendations = get_recommendations(prefs, 'Toby')
    assert_equal 3, recommendations.size
  end 
  #german book: page 20, top
  # please note that I get different results, order seems to be correct, though.
  # TODO: Needs investigation.
  def test_get_recommendations_with_sim_distance
    prefs = YAML.load_file('recommendations.yml')
    recommendations = get_recommendations(prefs, 'Toby') {|prefs, person, other| sim_distance(prefs, person, other)}
    assert_equal 3, recommendations.size
  end
  
  # just a small test to test the transformation described on page 21, middle (german book)
  def test_transform_preferences
    original = {'A' => {'1' => 1.0, '2' => 2.0}, 'B' => {'1' => 1.1, '2' => 2.1}}
    transformed = {'1' => {'A' => 1.0, 'B' => 1.1}, '2' => {'A' => 2.0, 'B' => 2.1}}
    assert_equal transformed, transform_preferences(original)
  end
  # german book: page 21, middle
  def test_top_matches_transformed
    prefs = YAML.load_file('recommendations.yml')
    matching = top_matches(transform_preferences(prefs), 'Superman Returns')
    expected_movies = ['You, me and Dupree', 'Lady in the Water', 'Snakes on a Plane', 'The Night Listener', 'Just my Luck']
    assert_equal expected_movies, matching.map{ |movie| movie.last }    
  end
  
  # german book: page 21, bottom
  def test_recommendations_transformed
    prefs = YAML.load_file('recommendations.yml')
    recommended = get_recommendations(transform_preferences(prefs), 'Just my Luck')
    expected_critics = ['Michael Phillips', 'Jack Matthews']
    assert_equal expected_critics, recommended.map{ |critic| critic.last }
  end
  
end