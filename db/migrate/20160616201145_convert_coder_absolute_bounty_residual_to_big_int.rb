class ConvertCoderAbsoluteBountyResidualToBigInt < ActiveRecord::Migration
  def change
    change_column(:coders, :absolute_bounty_residual, :bigint)
  end
end
