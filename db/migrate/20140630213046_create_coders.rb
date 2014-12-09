class CreateCoders < ActiveRecord::Migration
  def change
    create_table :coders do |t|
      t.string :github_name,      null: false
      t.string :full_name,        null: false, default: ''
      t.string :avatar_url,       null: false
      t.string :github_url,       null: false
      t.integer :reward_residual, null: false, default: 0
      t.integer :bounty_residual, null: false, default: 0
      t.integer :other_score,     null: false, default: 0

      t.timestamps
    end
    add_index(:coders, :github_name, unique: true)
    add_index(:coders, :github_url, unique: true)
  end
end
