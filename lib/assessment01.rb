require 'byebug'
class Array

  # Monkey patch the Array class and add a my_inject method. If my_inject receives
  # no argument, then use the first element of the array as the default accumulator.

  def my_inject(accumulator = nil, &prc)
    self_dup = self.dup
    accumulator.nil? ? ret = self_dup.shift : ret = accumulator
    self_dup.each do |el|
      ret = prc.call(ret, el)
    end
    ret
  end

end

# primes(num) returns an array of the first "num" primes.
# You may wish to use an is_prime? helper method.

def is_prime?(num)
  for i in (2..Math.sqrt(num))
    return false if num % i == 0
  end
  true
end

def primes(num)
  ret = []
  i = 2
  until ret.length >= num
    ret << i if is_prime?(i)
    i+=1
  end
  ret
end

# Write a recursive method that returns the first "num" factorial numbers.
# Note that the 1st factorial number is 0!, which equals 1. The 2nd factorial
# is 1!, the 3rd factorial is 2!, etc.

def factorials_rec(num)
  return [1] if num <= 1
  fact = factorials_rec(num-1)
  fact << (num-1) * fact.last
end

class Array

  # Write an Array#dups method that will return a hash containing the indices of all
  # duplicate elements. The keys are the duplicate elements; the values are
  # arrays of their indices in ascending order, e.g.
  # [1, 3, 4, 3, 0, 3, 0].dups => { 3 => [1, 3, 5], 0 => [4, 6] }

  def dups
    results = Hash.new {[]}
    self.each.with_index do |el1, pos1|
      self.each.with_index do |el2, pos2|
        results[el1] = results[el1] << pos1 if el1 == el2 && pos1 != pos2 && !results[el1].include?(pos1)
      end
    end
    results
  end
end

class String

  # Write a String#symmetric_substrings method that returns an array of substrings
  # that are palindromes, e.g. "cool".symmetric_substrings => ["oo"]
  # Only include substrings of length > 1.

  def symmetric_substrings
    results = []
    i = 0
    while i < self.length
      k = 0
      while k + i <= self.length
        subs = self[i..i+k]
        results << subs if subs == subs.reverse && subs.length > 1
        k+=1
      end
      i+=1
    end
    results.uniq
  end

end

class Array

  # Write an Array#merge_sort method; it should not modify the original array.

  def merge_sort(&prc)
    prc = Proc.new {|el1, el2| el1 <=> el2} unless prc
    return self if length <= 1
    left, right = self.take(length/2), self.drop(length/2)
    Array.merge(left.merge_sort, right.merge_sort, &prc)
  end

  private
  def self.merge(left, right, &prc)
    ret = []
    until left.empty? || right.empty?
      if prc.call(left.first, right.first) == -1
        ret << left.shift
      else
        ret << right.shift
      end
    end
    
    ret + left + right
  end
end
