class Coder < ActiveRecord::Base
  def total_score
    10 * commits + additions + modifications + bounty_score + other_score
  end
end
