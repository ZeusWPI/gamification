class ConvertTablesToUtf8 < ActiveRecord::Migration
  def change
    config = Rails.configuration.database_configuration
    db_name = config[Rails.env]["database"]
    collate = 'utf8mb4_bin'
    char_set = 'utf8mb4'
    row_format = 'DYNAMIC'
    innodb_file_format='Barracuda'
    innodb_file_per_table='ON'
    innodb_large_prefix='1'
    execute("ALTER DATABASE #{db_name} CHARACTER SET #{char_set} COLLATE #{collate}");
    execute("SET GLOBAL innodb_file_per_table=#{innodb_file_per_table}");
    execute("SET GLOBAL innodb_large_prefix=#{innodb_large_prefix}");
    execute("SET GLOBAL innodb_file_format=#{innodb_file_format}");
 
    ActiveRecord::Base.connection.tables.each do |table|
      execute("ALTER TABLE #{table} ROW_FORMAT=#{row_format};")
      execute("ALTER TABLE #{table} CONVERT TO CHARACTER SET #{char_set} COLLATE #{collate};")
    end
  end
end
