class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.string :full_name
      t.string :id_number
      t.date :date_of_birth
      t.text :address
      t.string :phone

      t.timestamps
    end
  end
end
