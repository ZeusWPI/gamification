class AddRepositoriesToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :repository_id, :integer, unique: true
    add_index :issues, :repository_id
    add_index :issues, [:repository_id, :number], unique: true

    reversible do |dir|
      dir.up do
        Issue.find_each do |issue|
          issue.update repository: Repositories.find_or_create_by(name: issue.repo)
        end
      end

      dir.down do
        Issue.find_each do |issue|
          issue.update repo: Repositories.find_by(name: issue.repository.name)
        end
      end
    end

    remove_index :issues, [:repo, :number]
    remove_column :issues, :repo, :string
  end
end
