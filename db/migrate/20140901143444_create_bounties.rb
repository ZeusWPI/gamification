class CreateBounties < ActiveRecord::Migration
  def change
    create_table :bounties do |t|
      t.integer :value
      t.references :issue, index: true
      t.references :coder, index: true

      t.timestamps
    end
  end
end
