class MakeBountyColumnsMoreLogical < ActiveRecord::Migration
  def change
    rename_column :bounties, :value, :absolute_value
    rename_column :coders, :bounty_residual, :absolute_bounty_residual
  end
end
