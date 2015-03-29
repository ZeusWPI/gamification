class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :name, index: true, unique: true, null: false
      t.timestamps
    end
  end
end
