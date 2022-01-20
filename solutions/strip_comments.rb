
def solution(input, markers)
  input.split("\n").map do |line|
    temp = ""
    markers.each do |mark|
      temp = line.split(mark).first if line.include?(mark)
    end
    temp = line if temp.empty?
    temp.strip
  end.join("\n")
end

test_cases = [
  {got: solution("apples, plums % and bananas\npears\noranges !applesauce", ['%', '!']),
   want: "apples, plums\npears\noranges" },

  {got: solution("Q @b\nu\ne -e f g", ['@', '-']),
   want: "Q\nu\ne" }
]


require_relative 'test'
test_cases.each do |tc|
  Test.assert_equals(tc[:got], tc[:want])
end
