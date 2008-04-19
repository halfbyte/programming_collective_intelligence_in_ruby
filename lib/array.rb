# this is a simple port of the sum function used in the book. it takes a block and sums all 
# results of calling the block with the 
# as a fallback it also may sum the elements itself (so it could, for clarity, also be used
# conjunction with map)
#

class Array
  def sum
    self.inject(0) do |sum, item|
      if block_given?
        sum += yield item
      else
        sum += item
      end
    end
  end
end
