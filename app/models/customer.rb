class Customer < ApplicationRecord
  has_one_attached :id_document

  validates :full_name, :id_number, :date_of_birth, :phone, :address,
            presence: true

  validate :customer_must_not_already_be_registered
  validate :id_document_must_be_valid

  private

  def customer_must_not_already_be_registered
    return if full_name.blank? || (date_of_birth.blank? && id_number.blank?)

    matching_name = self.class.where("LOWER(TRIM(full_name)) = ?", full_name.strip.downcase)
    matching_birth_date = matching_name.where(date_of_birth: date_of_birth)
    matching_id_number = matching_name.where("LOWER(TRIM(id_number)) = ?", id_number.to_s.strip.downcase)

    duplicate = matching_birth_date
      .or(matching_id_number)
      .where.not(id: id)
      .exists?

    if duplicate
      errors.add(:base, "A customer with this name and matching date of birth or ID number is already registered.")
    end
  end

  def id_document_must_be_valid
    unless id_document.attached?
      errors.add(:id_document, "must be uploaded")
      return
    end

    unless id_document.content_type.in?(%w[image/png image/jpeg])
      errors.add(:id_document, "must be a PNG or JPEG image")
    end

    if id_document.byte_size > 5.megabytes
      errors.add(:id_document, "must be smaller than 5 MB")
    end
  end
end
