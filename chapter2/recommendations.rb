#!/usr/bin/env ruby
require 'yaml'

def sim_distance(prefs, person1, person2)
  si = []
  prefs[person1].each do |k,v|
    if prefs[person2].has_key?(k)
      si << k
    end
  end
  
  return 0 if si.size == 0
  
  sum_of_squares = si.inject(0) do |sum, item|
    dist_square = ((prefs[person1][item] - prefs[person2][item]) ** 2)
    sum + dist_square 
  end
  puts sum_of_squares
  1/(1 + Math.sqrt(sum_of_squares))  
end

@critics = YAML.load_file('recommendations.yml')
