# frozen_string_literal: true

# == Schema Information
#
# Table name: ads
#
#  id          :bigint           not null, primary key
#  address     :string
#  city        :string
#  consent     :boolean
#  description :text
#  email       :string
#  kind        :integer          default("supply"), not null
#  phone       :string
#  service     :string           not null
#  zip         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Ad < ApplicationRecord
  KINDS = %w[supply demand].freeze
  SERVICES = ["Smještaj", "Prijevoz", "Usluga popravka", "Medicinska pomoć", "Ostalo"].freeze

  validates :city, presence: true
  validates :description, presence: true
  validates :phone, presence: true, on: %i[create update]
  validates :kind, presence: true, inclusion: { in: KINDS }
  validates :consent, presence: { message: "mora biti odobrena" }
  validates :address, presence: { message: "ne smije biti prazna" }, on: %i[create update]
  validates :email, format: /@/, if: -> { email.present? }
  validates :service, presence: true, inclusion: { in: SERVICES }

  enum kind: KINDS

  def accomodation?
    service == "Smještaj"
  end

  def transportation?
    service == "Prijevoz"
  end

  def repair_service?
    service == "Usluga popravka"
  end

  def medical_help?
    service == "Medicinska pomoć"
  end

  def other?
    service == "Ostalo"
  end

  def to_param
    [id, service.parameterize, city.parameterize].join("-")
  end

  def full_address
    [address, zip_and_city].select(&:present?).join(", ")
  end

  def zip_and_city
    [zip, city].select(&:present?).join(" ")
  end
end
