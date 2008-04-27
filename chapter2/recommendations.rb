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

# not sure about the best ruby-like implementation of the configurable sim_score function
# I started off with a symbol and send(symbol, etc) but that didn't feel right. passing
# a block definitely feels more ruby like...

def top_matches(prefs,person,n=5, &block)
  unless block
    block = lambda {|prefs, person, k| sim_pearson(prefs, person, k) }
  end
  scores = prefs.reject{ |k,v| k == person }.map{|k,v| [block.call(prefs, person, k), k]}
  scores.sort{|a,b| a.first <=> b.first }.reverse[0,n]
end

def get_recommendations(prefs,person, &block)
  unless block
    block = lambda {|prefs, person, k| sim_pearson(prefs, person, k) }
  end
  
  totals = {}
  sim_sums = {}
  # don't compare me to myself
  prefs.reject{ |k,v| k == person }.each do |name, items|
    sim=block.call(prefs,person,name)
    # ignore scores of zero or lower
    next if sim<=0
    items.each do |item, score|
      # only score movies I haven't seen yet
      if !prefs[person].has_key?(item) ||prefs[person][item] == 0
        # similarity * score
        totals[item] = 0 unless totals[item]
        totals[item] += score * sim
        # sum of similarities
        sim_sums[item] = 0 unless sim_sums[item]
        sim_sums[item] += sim
      end
    end
  end
  rankings = totals.map do |total_data|
    [total_data.last/sim_sums[total_data.first],total_data.first]
  end
  rankings.sort{|a,b| b.first <=> a.first}  
end

def transform_preferences(prefs)
  result = {}
  prefs.each do |person, person_prefs|
    person_prefs.each do |thing, rating|
      result[thing] ||= {}
      result[thing][person] = rating
    end
  end
  result
end
