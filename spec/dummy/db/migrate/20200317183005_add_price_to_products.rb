# frozen_string_literal: true

class AddPriceToProducts < ActiveRecord::Migration[6.0]
  def change
    change_table :products, bulk: true do |t|
      t.decimal :price
    end
  end
end
