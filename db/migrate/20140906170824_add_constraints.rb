class AddConstraints < ActiveRecord::Migration
  def change
    # Coders
    change_column_null(:coders, :github_name, false)
    change_column(:coders, :reward_residual, :integer, null: false, default: 0)
    change_column(:coders, :bounty_residual, :integer, null: false, default: 0)
    change_column(:coders, :additions, :integer, null: false, default: 0)
    change_column(:coders, :deletions, :integer, null: false, default: 0)
    change_column(:coders, :bounty_score, :integer, null: false, default: 0)
    change_column(:coders, :other_score, :integer, null: false, default: 0)
    add_index(:coders, :github_name, unique: true)
    add_index(:coders, :github_url, unique: true)

    # Issues
    change_column_null(:issues, :github_url, false)
    change_column_null(:issues, :repo, false)
    change_column_null(:issues, :number, false)
    change_column_null(:issues, :open, false)
    change_column(:issues, :title, :string, null: false, default: 'Untitled')
    change_column_null(:issues, :issuer_id, false)
    change_column_null(:issues, :labels, false, default: [].to_yaml)
    add_index(:issues, [:repo, :number], unique: true)
    add_index(:issues, :github_url, unique: true)

    # Bounties
    change_column_null(:bounties, :value, false)
    change_column_null(:bounties, :issue_id, false)
    change_column_null(:bounties, :coder_id, false)
    add_index(:bounties, [:issue_id, :coder_id], unique: true)
  end
end
