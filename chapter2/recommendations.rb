require '../lib/examples_helper'

# TODO: This probably belongs into a module

def sim_distance(prefs, person1, person2)
  si = prefs[person1].keys & prefs[person2].keys
  return 0 if si.size == 0
  
  sum_of_squares = si.inject(0) do |sum, item|
    sum + ((prefs[person1][item] - prefs[person2][item]) ** 2)
  end
  1/(1 + Math.sqrt(sum_of_squares))  
end

def sim_pearson(prefs, person1, person2)
  si = prefs[person1].keys & prefs[person2].keys
  return 0 if si.size == 0
  sum1 = si.sum {|k| prefs[person1][k] }
  sum2 = si.sum {|k| prefs[person2][k] }
  sum1_sq = si.sum {|k| prefs[person1][k] ** 2 }
  sum2_sq = si.sum {|k| prefs[person2][k] ** 2 }
  p_sum = si.sum { |k| (prefs[person1][k] * prefs[person2][k])}
  num = p_sum - (sum1 * sum2 / si.size)
  den = Math.sqrt((sum1_sq - (sum1 ** 2) / si.size) * (sum2_sq-(sum2 ** 2)/ si.size))
  return 0 if den == 0
  num/den
end