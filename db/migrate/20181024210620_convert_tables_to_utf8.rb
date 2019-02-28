class ConvertTablesToUtf8 < ActiveRecord::Migration
  def change
    config = Rails.configuration.database_configuration
    db_name = config[Rails.env]["database"]
    collate = 'utf8mb4_bin'
    char_set = 'utf8mb4'
    row_format = 'DYNAMIC'
    execute("ALTER DATABASE #{db_name} CHARACTER SET #{char_set} COLLATE #{collate};");
 
    ActiveRecord::Base.connection.tables.each do |table|
      execute("ALTER TABLE #{table} ROW_FORMAT=#{row_format};")
      execute("ALTER TABLE #{table} CONVERT TO CHARACTER SET #{char_set} COLLATE #{collate};")
    end
  end
end
