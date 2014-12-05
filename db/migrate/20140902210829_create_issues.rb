class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :github_url,     null: false
      t.integer :number,        null: false
      t.string :title,          null: false, default: 'Untitled'
      t.references :issuer,     null: false
      t.references :repository, null: false, index: true
      t.text :labels,           null: false, default: [].to_yaml
      t.text :body
      t.integer :assignee_id
      t.string :milestone

      t.timestamp :opened_at, null: false
      t.timestamp :closed_at

      t.timestamps
    end
    add_index(:issues, [:repository_id, :number], unique: true)
    add_index(:issues, :github_url, unique: true)
  end
end
