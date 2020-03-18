# frozen_string_literal: true

# An expensive operation that recursively maximizes all products prizes and
# all child categories and their product prices
module UpdateChildrenPrice
  FACTOR = 0.5
  NUMBER = 3

  # Public

  def self.maximize_all(root_category, upper_limit = 94, lower_limit = 93)
    Blazar.beam(scopes: [Category.all, Product.all]) do
      child_products(root_category).each do |product|
        maximize(product, upper_limit, lower_limit)
      end

      child_products(root_category).each do |product|
        maximize(product, upper_limit / 2, (lower_limit - 1) / 2)
      end
    end
  end

  # Private

  def self.maximize(product, upper_limit, lower_limit)
    price = product.price

    if price >= lower_limit
      return if price <= upper_limit

      # decrease by division
      multiply(product, FACTOR)
    else
      # increase by addition
      add(product, NUMBER)
    end

    maximize(product, upper_limit, lower_limit)
  end

  def self.multiply(product, factor)
    price = product.price * factor
    product.price = price.round.to_f

    product.save!
  end

  def self.add(product, number)
    product.price += number

    product.save!
  end

  def self.child_products(root_category)
    Product.where(category: child_categories(root_category) + [root_category])
  end

  def self.child_categories(root_category)
    Category.where(category_id: root_category.id)
  end

  private_class_method :maximize, :multiply, :add, :child_products,
                       :child_categories
end
