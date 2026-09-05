class CleanDuplicateCustomerIds < ActiveRecord::Migration[7.0]
  class MigrationCustomer < ActiveRecord::Base
    self.table_name = "customers"
  end

  def up
    grouped_ids = Hash.new { |hash, key| hash[key] = [] }

    MigrationCustomer.where.not(id_number: [ nil, "" ]).find_each do |customer|
      normalized_id = customer.id_number.to_s.gsub(/[^a-zA-Z0-9]/, "").upcase
      customer.update_columns(id_number: normalized_id)
      grouped_ids[normalized_id] << customer.id
    end

    grouped_ids.each_value do |ids|
      ids.drop(1).each do |duplicate_id|
        MigrationCustomer.where(id: duplicate_id).delete_all
      end
    end

    add_index :customers, :id_number, unique: true
  end

  def down
    remove_index :customers, :id_number
  end
end
