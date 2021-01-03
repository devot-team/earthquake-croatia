# frozen_string_literal: true

# == Schema Information
#
# Table name: ads
#
#  id          :bigint           not null, primary key
#  address     :string
#  category    :integer          default(0), not null
#  city        :string
#  consent     :boolean
#  description :text
#  email       :string
#  kind        :integer          default("supply"), not null
#  phone       :string
#  zip         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Ad < ApplicationRecord
  CATEGORIES = %w[
    accomodation
    transport
    repairs
    medical_assistance
    other
    building_material
    kids
    diet_and_hygiene
    furniture_and_household
    clothes_and_shoes
  ].freeze
  KINDS = %w[supply demand].freeze

  validates :city, presence: true
  validates :description, presence: true
  validates :phone, presence: true, on: %i[create update]
  validates :kind, presence: true, inclusion: { in: KINDS }
  validates :consent, presence: { message: "mora biti odobrena" }
  validates :address, presence: { message: "ne smije biti prazna" }, on: %i[create update]
  validates :email, format: /@/, if: -> { email.present? }
  validates :categories, presence: true, inclusion: { in: CATEGORIES }

  enum category: CATEGORIES
  enum kind: KINDS

  def to_param
    [id, category.parameterize, city.parameterize].join("-")
  end

  def full_address
    [address, zip_and_city].select(&:present?).join(", ")
  end

  def zip_and_city
    [zip, city].select(&:present?).join(" ")
  end
end
