class ConvertCoderAbsoluteBountyResidualToBigInt < ActiveRecord::Migration[4.2]
  def change
    change_column(:coders, :absolute_bounty_residual, :bigint)
  end
end
