# frozen_string_literal: true

module Blazar
  # This module extracts useful information from rails schema
  module Schema
    # Public API

    def self.clean(schema_contents)
      remove_comments(remove_options(schema_contents))
    end

    def self.filter(schema_contents, table_names)
      filter_tables(schema_contents, table_names)
    end

    # Private Methods

    def self.remove_options(schema_contents)
      schema_contents.split("\n").map do |line|
        # To ignore ENGINE and other options
        line.gsub(/, options: .*,/, ',')
      end.join("\n")
    end

    def self.remove_comments(schema_contents)
      schema_contents.split("\n").map do |line|
        line.gsub(/#.*/, '')
      end.reject(&:empty?).join("\n")
    end

    def self.filter_tables(schema_contents, table_names)
      write_table = false

      schema_contents.split("\n").map do |line|
        if line =~ /ActiveRecord::Schema.define.*/
          line
        elsif table_names.any? { |t| line =~ /create_table \"#{t}\"/ }
          write_table = true
          line
        elsif table_names.any? { |t| line =~ /add_foreign_key \"#{t}\"/ }
          write_table = true
          line
        elsif line =~ /end/ && write_table
          write_table = false
          line
        elsif write_table
          line
        else
          ''
        end
      end.join("\n")
    end

    private_class_method :remove_options, :remove_comments
  end
end
