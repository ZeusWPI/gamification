class CreateBounties < ActiveRecord::Migration
  def change
    create_table :bounties do |t|
      t.integer :value,    null: false
      t.references :issue, null: false, index: true
      t.references :coder, null: false, index: true

      t.timestamps
    end
    add_index(:bounties, [:issue_id, :coder_id], unique: true)
  end
end
