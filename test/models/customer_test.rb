require "test_helper"

class CustomerTest < ActiveSupport::TestCase
  test "rejects a duplicate name and date of birth when ID and address differ" do
    existing_customer = customers(:one)
    duplicate = Customer.new(
      full_name: existing_customer.full_name.upcase,
      id_number: "DIFFERENT-ID",
      date_of_birth: existing_customer.date_of_birth,
      address: "Different address",
      phone: "555-0100"
    )

    duplicate.valid?

    assert_includes duplicate.errors[:base],
                    "A customer with this name and matching date of birth or ID number is already registered."
  end

  test "rejects the same ID, name, and date of birth with a different address" do
    existing_customer = customers(:one)
    duplicate = Customer.new(
      full_name: existing_customer.full_name,
      id_number: existing_customer.id_number,
      date_of_birth: existing_customer.date_of_birth,
      address: "Different address",
      phone: "555-0100"
    )

    duplicate.valid?

    assert_includes duplicate.errors[:base],
                    "A customer with this name and matching date of birth or ID number is already registered."
  end

  test "rejects the same name and ID with a different date of birth" do
    existing_customer = customers(:one)
    duplicate = Customer.new(
      full_name: existing_customer.full_name,
      id_number: existing_customer.id_number.downcase,
      date_of_birth: existing_customer.date_of_birth + 1.year,
      address: "Different address",
      phone: "555-0100"
    )

    duplicate.valid?

    assert_includes duplicate.errors[:base],
                    "A customer with this name and matching date of birth or ID number is already registered."
  end

  test "allows the same name with a different date of birth" do
    existing_customer = customers(:one)
    candidate = Customer.new(
      full_name: existing_customer.full_name,
      id_number: "DIFFERENT-ID",
      date_of_birth: existing_customer.date_of_birth + 1.day,
      address: "Different address",
      phone: "555-0100"
    )

    candidate.valid?

    assert_empty candidate.errors[:base]
  end

  test "allows different customers to share an ID number" do
    first_customer = build_customer("First Customer", "SHARED-ID", Date.new(1980, 1, 1))
    second_customer = build_customer("Second Customer", "SHARED-ID", Date.new(1985, 1, 1))

    assert first_customer.save
    assert second_customer.save
  end

  private

  def build_customer(full_name, id_number, date_of_birth)
    customer = Customer.new(
      full_name: full_name,
      id_number: id_number,
      date_of_birth: date_of_birth,
      address: "Sample address",
      phone: "555-0100"
    )
    customer.id_document.attach(
      io: StringIO.new("test image"),
      filename: "id.png",
      content_type: "image/png"
    )
    customer
  end
end
