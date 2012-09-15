require "closync/version"
require "closync/config"

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
  end
end
