class TimeCalc
  SECOND = 1
  MINUTE = SECOND * 60
  HOUR = MINUTE * 60
  DAY = HOUR * 24
  YEAR = DAY * 365

  def initialize(seconds)
    @seconds = seconds
    @data = {
      year: 0,
      day: 0,
      hour: 0,
      minute: 0,
      second: 0
    }
  end

  def call
    # Hashes enumerate their values in the order that the corresponding keys were inserted.
    rem = seconds
    data.update(data) do |k, _v|
      sec = rem
      val = Object.const_get("TimeCalc::#{k.upcase}")
      rem %= val
      (sec - (sec % val)) / val
    end
  end

  private

  attr_reader :data, :seconds
end

class TimeFormatter
  def initialize(data)
    @data = data.reject { |_k, v| v.zero? }
  end

  # this is still pretty meh
  def call
    formatter = data.map { |k, v| "#{v} #{pluralize(k.to_s, v)}" }
    formatter.insert(-2, 'and') if formatter.size > 1
    formatter.join(', ').gsub(', and,', ' and')
  end

  def pluralize(string, num)
    string += 's' if num > 1
    string
  end

  private

  attr_reader :data
end

def format_duration(seconds)
  return 'now' if seconds.zero?

  time_hash = TimeCalc.new(seconds).call
  TimeFormatter.new(time_hash).call
end

class Test
  def self.assert_equals(a, b)
    puts a == b
  end
end

Test.assert_equals(format_duration(0), 'now')
Test.assert_equals(format_duration(1), '1 second')
Test.assert_equals(format_duration(62), '1 minute and 2 seconds')
Test.assert_equals(format_duration(120), '2 minutes')
Test.assert_equals(format_duration(3600), '1 hour')
Test.assert_equals(format_duration(3662), '1 hour, 1 minute and 2 seconds')
Test.assert_equals(format_duration(3600 * 24 * 365), '1 year')

# ok we need to work out the times first and save them in a data structure
# this is a greedy algo for sure
# lets do year/day/hour/min/second
