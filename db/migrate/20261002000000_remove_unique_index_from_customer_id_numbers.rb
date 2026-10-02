class RemoveUniqueIndexFromCustomerIdNumbers < ActiveRecord::Migration[8.0]
  def change
    remove_index :customers, column: :id_number, name: "index_customers_on_id_number"
  end
end
