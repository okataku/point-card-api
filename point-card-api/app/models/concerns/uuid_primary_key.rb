module UuidPrimaryKey
  extend ActiveSupport::Concern

  included do
    before_create :set_uuid_primary_key
  end

  class_methods do
    def uuid_primary_keys
      # The columns is detected if it is primary key and is string data type.
      primary_keys = ActiveRecord::Base.connection.primary_keys(self.table_name)
      primary_keys.each_with_object([]) do |pk, results|
        column = self.columns_hash[pk]
        results << column.name if column.type == :string
      end
    end
  end

  def set_uuid_primary_key
    self.class.uuid_primary_keys.each do |pk|
      loop do
        uuid = SecureRandom.uuid
        unless self.class.exists?({pk => uuid})
          self[pk] = uuid
          break;
        end
      end
    end
  end

end