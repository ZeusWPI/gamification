class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.references :coder, index: true
      t.references :repository, index: true
      t.string :sha
      t.integer :additions
      t.integer :deletions
      t.datetime :date

      t.timestamps
    end
    add_index :commits, [:repository_id, :sha], unique: true
  end
end
