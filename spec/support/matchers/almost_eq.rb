RSpec::Matchers.define :almost_eq do |expected|
  epsilon = 1

  match do |actual|
    (expected - actual).abs <= epsilon
  end

  chain :with_epsilon do |custom_epsilon|
    epsilon = custom_epsilon
  end
end
