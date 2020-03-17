# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :category

  validates :category_id, :name, :price, presence: true
  validates :name, uniqueness: true
end
