class CreateBounties < ActiveRecord::Migration
  def change
    create_table :bounties do |t|
      t.integer :value,        null: false
      t.references :issue,     null: false, index: true
      t.references :issuer,    null: false, index: true
      t.references :claimant,  index: true
      t.integer :claimed_value
      t.timestamp :claimed_at, index: true

      t.timestamps
    end
    add_index :bounties, [:issue_id, :issuer_id]
  end
end
