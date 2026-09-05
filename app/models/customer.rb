class Customer < ApplicationRecord
  has_one_attached :id_document

  validates :full_name, :id_number, :date_of_birth, :phone, :address,
            presence: true

  validate :id_document_must_be_valid

  private

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
