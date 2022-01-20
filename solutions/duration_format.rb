

def format_duration(seconds)

  time_values = [31536000, 86400, 3600, 60, 1].reverse
  time_names = ["year", "day", "hour", "minute", "second"].reverse

  # pop will return an array so we dont need this assignment
  # last_units = []

  return "now" if seconds.zero?
  calculated_times = calculate_time(seconds, [] ,time_values, time_names).compact

  last_units = calculated_times.pop(2)

  return last_units.join(" and ") if calculated_times.empty?

  calculated_times.join(", ").concat(", ").concat(last_units.join(" and "))
end

def calculate_time(seconds_remaining, array, time_values, time_names)
  # recursive guard clause / base case at the top so we know when this function will return
  return array if seconds_remaining.zero?

  # remove an element from each array
  time_value = time_values.pop
  time_name = time_names.pop

  # do all of the things
  time_calculated = seconds_remaining / time_value
  array << format_time_period(time_calculated, time_name)
  seconds_remaining = seconds_remaining % time_value

  # recurse <3
  calculate_time(seconds_remaining, array, time_values, time_names)
end

def format_time_period(time, name)
  return if time.zero?
  string = "#{time} "
  format = time == 1 ? name : name + "s"
  string << format
end

require_relative 'test'

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
