# frozen_string_literal: true

# An expensive operation that recursively maximizes all products prizes and
# all child categories and their product prices
module UpdateChildrenPrice
  FACTOR = 0.5
  NUMBER = 3

  # Public

  def self.maximize_all(root_category, upper_limit = 94, lower_limit = 93)
    child_products(root_category).each do |product|
      maximize(product, upper_limit, lower_limit)
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
    product.price *= factor
    product.price = product.price.round.to_f

    product.save!
  end

  def self.add(product, number)
    product.price += number

    product.save!
  end

  def child_products(root_category)
    Product.where(category: child_categories + [root_category])
  end

  def child_categories(root_category)
    Category.where(category_id: root_category.id)
  end

  private_class_method :maximize, :multiply, :add, :child_products,
                       :child_categories
end
