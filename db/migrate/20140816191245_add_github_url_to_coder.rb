class AddGithubUrlToCoder < ActiveRecord::Migration
  def change
    add_column :coders, :github_url, :string
  end
end
