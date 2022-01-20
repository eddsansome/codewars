def score(dice)
  total = 0
  score_tally = dice.group_by {|t| t }.each_with_object({}) {|o,h| h[o[0]] = o[1].size }
  total += greeds(score_tally) if greed?(score_tally)
  total += singles(score_tally)
  total
end

def greed?(rolls)
  rolls.any? {|_,v| v >= 3 }
end

def greeds(rolls)
  multi_scores(rolls.select {|_,v| v >= 3 }.to_a.flatten.first)
end

def singles(rolls)
  rolls.select {|k, _| k == 1 || k == 5 }.to_a.map do |e|
    totie = e[1]
    totie -= 3 if totie >= 3
    single_scores(e[0]) * totie
  end.sum
end

def multi_scores(num)
  {
    1 => 1000,
    6 => 600,
    5 => 500,
    4 => 400,
    3 => 300,
    2 => 200
  }[num]
end

def single_scores(num)
  {
    1 => 100,
    5 => 50,
  }[num]
end








require_relative 'test'
Test.assert_equals(score([2, 3, 4, 6, 2] ), 0);
Test.assert_equals(score([2, 2, 2, 3, 3] ), 200);
Test.assert_equals(score([2, 4, 4, 5, 4] ), 450);
