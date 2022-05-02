class CreateGitIdentities < ActiveRecord::Migration[4.2]
  def change
    create_table :git_identities do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.references :coder, index: true

      t.timestamps
    end
    add_index :git_identities, [:name, :email], unique: true
  end
end
