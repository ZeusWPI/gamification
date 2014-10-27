class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :github_url
      t.integer :number
      t.string :repo
      t.boolean :open
      t.string :title
      t.string :body
      t.integer :issuer_id
      t.text :labels
      t.integer :assignee_id
      t.string :milestone

      t.timestamps
    end
  end
end
