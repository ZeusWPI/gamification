class MakeBountyColumnsMoreLogical < ActiveRecord::Migration[4.2]
  def change
    rename_column :bounties, :value, :absolute_value
    rename_column :coders, :bounty_residual, :absolute_bounty_residual
  end
end
