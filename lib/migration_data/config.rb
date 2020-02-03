module MigrationData
  @config = Struct.new(:skip).new(false)

  def self.config
    @config
  end
end
