class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :name, index: true, unique: true, null: false
      t.string :github_url,                      null: false
      t.string :clone_url,                       null: false
      t.timestamps
    end
  end
end
