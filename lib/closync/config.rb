require 'erb'

module Closync
  class Config

    # Fog config
    attr_accessor :credentials
    attr_accessor :storage
    attr_accessor :cache_control

    # Git
    attr_accessor :branch


    def initialize(path)
      self.credentials    = {}
      self.storage        = {}
      self.cache_control  = {}
      self.branch         = []

      @yml_path = (path || "#{Dir.pwd}/.closync.yml")

      self.load_yml! if self.yml_exists?
    end

    def load_yml!
      yml = read_yml
      yml['credentials'].each do |key, val|
        self.credentials[key] = val
      end
      yml['storage'].each do |key, val|
        self.storage[key] = val
      end
      yml['cache_control'].each do |key, val|
        self.cache_control[key] = val
      end
      yml['branch'].each do |branch|
        self.branch << branch
      end
    end

    def read_yml
      YAML.load(ERB.new(IO.read(@yml_path)).result) rescue nil || {}
    end

    def yml_exists?
      File.exists?(@yml_path)
    end

  end
end
