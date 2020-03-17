# frozen_string_literal: true

module Blazar
  # Manages tables in an AR adapter
  module Tables
    # Public API

    def self.lock(options)
      return unless options.lock

      lock_tables(options.tables)
    end

    def self.unlock(options)
      return unless options.lock

      unlock_tables(options.tables)
    end

    # Private Methods

    def self.lock_tables(table_names)
      # TODO: Implement this
    end

    def self.unlock_tables(table_names)
      # TODO: Implement this
    end

    private_class_method :lock_tables, :unlock_tables
  end
end
