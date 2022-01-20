require_relative 'test'

class Integer
  N_BYTES = [42].pack('i').size
  N_BITS = N_BYTES * 16
  MAX = 2**(N_BITS - 2) - 1
  MIN = -MAX - 1
end

def max_sequence(arr)
  max_seen = 0
  max_end = 0

  arr.size.times do |i|
    puts "max seen #{max_seen}"
    puts "max end #{max_end}"
    max_end += arr[i]
    max_seen = max_end if max_seen < max_end
    max_end = 0 if max_end < 0
  end
  max_seen
end

# Test.assert_equals(max_sequence([]), 0)
Test.assert_equals(max_sequence([-2, 1, -3, 4, -1, 2, 1, -5, 4]), 6)
# Test.assert_equals(max_sequence([11]), 11)
# Test.assert_equals(max_sequence([-32]), 0)
# Test.assert_equals(max_sequence([-2, 1, -7, 4, -10, 2, 1, 5, 4]), 12)
