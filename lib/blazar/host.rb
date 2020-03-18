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

      scopes = @scopes.map(&:to_a).flatten

      ActiveRecord::Base.establish_connection(host_params)
      ActiveRecord::Schema.verbose = false

      load_schema(scopes)

      new_records =
        ActiveRecord::Base.transaction(requires_new: true) do
          scopes.map do |record|
            new_record = record.dup
            new_record.id = record.id
            new_record.save!
            new_record
          end
        end

      ActiveRecord::Base.transaction(requires_new: true) do
        yield
      end

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

        # skip validations & callbacks ?
        record.update_columns(attrs)
      end
    end

    private

    def host_from_host_options(host_options)
      @host_type = host_options[:type]
      @host_params = host_options[:params]
    end

    def load_schema(scopes)
      schema_contents = File.read(Rails.root.join('db', 'schema.rb'))
      schema_contents = Blazar::Schema.clean(schema_contents)
      table_names = table_names_from_scopes(scopes)
      schema_contents = Blazar::Schema.filter(schema_contents, table_names)

      # TODO: Think about a better way to get this
      eval(schema_contents)
    end

    def table_names_from_scopes(scopes)
      # two uniques for STI
      scopes.map(&:class).uniq.map(&:table_name).uniq
    end
  end
end
