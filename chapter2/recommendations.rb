#!/usr/bin/env ruby
require 'yaml'
#
# NOTE: I put the critics data into a yaml file to make it easier to base other language examples on it.
#

#
# INFO: Both the code and the result of the original python version from the book are
# broken, so don't expect the sim_distance function to return the result stated in the book.
#
def sim_distance(prefs, person1, person2)
  si = []
  prefs[person1].each do |k,v|
    if prefs[person2].has_key?(k)
      si << k
    end
  end
  
  return 0 if si.size == 0
  
  sum_of_squares = si.inject(0) do |sum, item|
    sum + ((prefs[person1][item] - prefs[person2][item]) ** 2)
  end
  puts sum_of_squares
  1/(1 + Math.sqrt(sum_of_squares))  
end

def sim_pearson(prefs, person1, person2)
  si = []
  prefs[person1].each do |k,v|
    if prefs[person2].has_key?(k)
      si << k
    end
  end  
  return 0 if si.size == 0

  sum1 = si.inject(0) { |sum, k| sum + prefs[person1][k] }
  sum2 = si.inject(0) { |sum, k| sum + prefs[person2][k] }
  sum1_sq = si.inject(0) { |sum, k| sum + (prefs[person1][k] ** 2) }
  sum2_sq = si.inject(0) { |sum, k| sum + (prefs[person2][k] ** 2) }

  p_sum = si.inject(0) { |sum, k| sum + (prefs[person1][k] * prefs[person2][k])}

  num = p_sum - (sum1 * sum2 / si.size)
  den = Math.sqrt((sum1_sq - (sum1 ** 2) / si.size) * (sum2_sq-(sum2 ** 2)/ si.size))
  return 0 if den == 0
  num/den
end

@critics = YAML.load_file('recommendations.yml')
