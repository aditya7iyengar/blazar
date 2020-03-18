# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateChildrenPrice do
  describe '.maximize_all' do
    let!(:product1) do
      FactoryBot.create(
        :product,
        name: 'product1',
        price: 44
      )
    end

    let!(:product2) do
      FactoryBot.create(
        :product,
        name: 'product2',
        category_id: product1.category_id,
        price: 46
      )
    end

    before do
      50.times do |index|
        FactoryBot.create(
          :product,
          name: "product#{index + 3}",
          category_id: product1.category_id,
          price: index
        )
      end
    end

    it 'updates product1 price to 93' do
      expect do
        bm = Benchmark.measure do
          described_class.maximize_all(product1.category)
        end

        puts bm
        product1.reload
      end.to change(product1, :price).from(44).to(47)
    end

    it 'updates product2 price to 94' do
      expect do
        described_class.maximize_all(product1.category)
        product2.reload
      end.to change(product2, :price).from(46).to(47)
    end
  end
end
