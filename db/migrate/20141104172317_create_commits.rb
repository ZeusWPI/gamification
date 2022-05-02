class CreateCommits < ActiveRecord::Migration[4.2]
  def change
    create_table :commits do |t|
      t.references :coder,      index: true
      t.references :repository, index: true
      t.string :sha,            null: false
      t.integer :additions,     null: false, default: 0
      t.integer :deletions,     null: false, default: 0
      t.timestamp :date,        null: false, index: true

      t.timestamps
    end
    add_index :commits, [:repository_id, :sha], unique: true
  end
end
