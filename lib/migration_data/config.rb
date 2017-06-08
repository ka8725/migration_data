module MigrationData
  @config = Struct.new(:skip_data_on_test).new(false)
  def self.config
    @config
  end
end
