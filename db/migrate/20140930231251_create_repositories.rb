class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :name, null: false
      t.references :organisation, null: false
      t.integer :hook_id

      t.timestamps
    end
    add_index :repositories, [:organisation_id, :name], unique: true
  end
end
