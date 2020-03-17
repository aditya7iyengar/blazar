# frozen_string_literal: true

module Blazar
  Options = Struct.new(:scopes, :host, :lock)

  # Represents structure for options to be used for a Blazar call
  class Options
    DEFAULT_HOST = {
      type: 'sqlite',
      params: { adapter: 'sqlite3', database: ':memory:' }
    }.freeze

    DEFAULT_LOCK = false

    # Initializes an options instance
    # * scopes: required
    # * lock: Defaults to `false`
    # * host: Defaults to `'sqlite'`
    def initialize(scopes:, lock: DEFAULT_LOCK, host: DEFAULT_HOST)
      validate!(scopes, lock, host)
      super(scopes, host, lock)
    end

    private

    def validate!(_scopes, _lock, _host)
      # TODO: Add more validations here
      true
    end
  end
end
