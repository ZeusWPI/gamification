class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :user, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
