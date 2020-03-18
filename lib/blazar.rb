# frozen_string_literal: true

require 'blazar/railtie'

require 'blazar/options'
require 'blazar/schema'
require 'blazar/host'

# Documentation for Blazar
module Blazar
  # Public API

  # API to interact with Blazar and host/run a part of your rails application
  # code inside the specified (or default) host
  #
  # For information on `options` refer `lib/blazar/options.rb`
  #
  # `scopes` should be in the order of dependency
  #
  # For guidelines on when to use `Blazar` refer to the `README`
  #
  # Example:
  # product = Product.first
  # Blazar.beam(scopes: [Category.all, Produce.all], lock: true) do
  #   some_expensive_operation(product)
  # end
  def self.beam(options)
    options = validate_and_extract_options(options)

    host = Host.new(options)
    host.encapsulate { yield }
  end

  # Private Methods

  def self.validate_and_extract_options(options)
    Options.new(options)
  end

  private_class_method :validate_and_extract_options
end
