# frozen_string_literal: true

module Blazar
  # Represents the state of the host that's running relativistic job
  class Host
    attr_reader :host_type, :host_params, :scopes

    def initialize(options)
      host_from_host_options(options.host)
      @scopes = options.scopes
    end

    def encapsulate
      old_config = ActiveRecord::Base.connection_config

      scopes = @scopes.map(&:to_a)

      ActiveRecord::Base.establish_connection(host_params)
      ActiveRecord::Schema.verbose = false

      eval(`cat #{Rails.root.join('db', 'schema.rb')} | sed 's/,[^:]*: :serial\//g'`)

      new_records =
        scopes.flatten.map do |record|
          new_record = record.dup
          new_record.id = record.id
          new_record.save!
          new_record
        end

      yield

      new_records = new_records.map(&:reload)

      ActiveRecord::Base.establish_connection(old_config)

      new_records.each do |new_record|
        record = new_record.dup
        record.id = new_record.id
        record.reload
        attrs =
          new_record.attributes.delete_if do |key, _value|
            %w[id created_at updated_at].include?(key)
          end

        record.update_attributes(attrs)
      end
    end

    private

    def host_from_host_options(host_options)
      @host_type = host_options[:type]
      @host_params = host_options[:params]
    end
  end
end
