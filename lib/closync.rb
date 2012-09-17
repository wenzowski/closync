require 'closync/version'
require 'closync/config'
require 'closync/storage'
require 'closync/sync'

module Closync
  class << self
    def config=(data)
      @config = data
    end

    def config
      @config ||= Config.new
      @config
    end

    def configure(&proc)
      @config ||= Config.new
      yield @config
    end

    def push!
      Sync.new(config).push!
    end
  end
end
