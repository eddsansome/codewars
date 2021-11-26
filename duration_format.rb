class TimeCalc
  SECOND = 1
  MINUTE = SECOND * 60
  HOUR = MINUTE * 60
  DAY = HOUR * 24
  YEAR = DAY * 365

  def initialize(seconds)
    @seconds = seconds
    # do we need all of them?
    # we could even turn this into a struct? :thinkings
    @data = {
      years: 0,
      days: 0,
      hours: 0,
      minutes: 0,
      seconds: 0 }
  end

  # we could use #then here and pass the value to the next in the chain
  def call
    data[:years] = (seconds - (seconds % YEAR)) / YEAR
    seconds1 = seconds % YEAR
    data[:days] = (seconds1 - (seconds1 % DAY)) / DAY
    seconds2 = seconds1 % DAY
    data[:hours]= (seconds2 - (seconds2 % HOUR)) / HOUR
    seconds3 = seconds2 % HOUR
    data[:minutes] = (seconds3 - (seconds3 % MINUTE)) / MINUTE
    data[:seconds] = seconds3 % MINUTE
    data
  end

  private

  attr_reader :data, :seconds

end

  class TimeFormatter
    def initialize(data)
      # do we even need the extra keys doe??
      @data = data.reject { |k,v| v.zero? }
    end

    # what a mess
    # we could probably use #each_with_object here to tidy this up
    def call
      formatter = []
      formatter << "#{data[:years]} #{pluralize("year", data[:years])}" if data[:years]
      formatter << "#{data[:days]} #{pluralize("day", data[:days])}" if data[:days] 
      formatter << "#{data[:hours]} #{pluralize("hour", data[:hours])}" if data[:hours]
      formatter << "#{data[:minutes]} #{pluralize("minute", data[:minutes])}" if data[:minutes]
      formatter << "#{data[:seconds]} #{pluralize("second", data[:seconds])}" if data[:seconds]
      # need that and
      formatter.insert(-2,'and') if formatter.size > 1
      # giggle
      formatter.join(', ').gsub(', and,', ' and')
    end
    # this could be extracted / monkey patch string?? :troll
    def pluralize(string, num)
      string += 's' if num > 1
      string
    end
    private

    attr_reader :data
  end

def format_duration(seconds)
  return "now" if seconds.zero?
  time_hash = TimeCalc.new(seconds).call
  TimeFormatter.new(time_hash).call
end

class Test 
  def self.assert_equals(a,b)
    puts a == b
  end
end

Test.assert_equals(format_duration(0), "now")
Test.assert_equals(format_duration(1), "1 second")
Test.assert_equals(format_duration(62), "1 minute and 2 seconds")
Test.assert_equals(format_duration(120), "2 minutes")
Test.assert_equals(format_duration(3600), "1 hour")
Test.assert_equals(format_duration(3662), "1 hour, 1 minute and 2 seconds")
Test.assert_equals(format_duration(3600*24*365), "1 year")

# ok we need to work out the times first and save them in a data structure
# this is a greedy algo for sure
# lets do year/day/hour/min/second
