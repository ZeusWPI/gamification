class ConvertCoderAbsoluteBountyResidualToBigInt < ActiveRecord::Migration
  def change
    change_column(:coder, :absolute_bounty_residual, :bigint)
  end
end
