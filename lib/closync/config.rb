module Closync
  class Config

    # Fog config
    attr_accessor :credentials
    attr_accessor :storage
    attr_accessor :cache_control

    # Git
    attr_accessor :branch


    def initialize(opts={})
      self.credentials    = {}
      self.storage        = {}
      self.cache_control  = {}
      self.branch         = []

      @yml_path = ( opts[:yml_path] || "#{Dir.pwd}/.closync.yml" )

      if self.yml_exists?
        load_yml!
      else
        raise "Config file not found at #{opts[:yml_path]}" if opts[:yml_path]
      end
    end

    def yml_path
      @yml_path
    end

    def yml_exists?
      File.exists?(self.yml_path)
    end

    def max_age(extension)
      self.cache_control[extension] || self.cache_control['default'] ||
        (raise 'No default max-age configured.')
    end

    def set_max_age!(extension, max_age)
      self.cache_control[extension] = max_age
    end

    def local
      storage[:local] || (raise 'No local storage configured.')
    end

    def local=(config={})
      raise 'Config must include :provider and :directory.' unless
        config.keys == [:provider, :directory]
      storage[:local] = {}
      storage[:local][:provider] = config[:provider]
      storage[:local][:directory] = config[:directory]
    end

    def remote
      storage[:remote] || (raise 'No remote storage configured.')
    end

    def remote=(config={})
      raise 'Config must include :provider and :directory.' unless
        config.keys == [:provider, :directory]
      storage[:remote] = {}
      storage[:remote][:provider] = config[:provider]
      storage[:remote][:directory] = config[:directory]
    end

    private

      def load_yml!
        read_yml!
        set_credentials!
        set_storage!
        set_cache_control!
        set_branch!
      end

      def read_yml
        YAML.load(ERB.new(IO.read(self.yml_path)).result) rescue nil || {}
      end

      def read_yml!
        @yml = read_yml
      end

      def set_credentials!
        self.credentials = {}
        @yml['credentials'].each do |key, val|
          self.credentials[key.to_sym] = val
        end if @yml['credentials']
      end

      def set_storage!
        self.storage = {}
        @yml['storage'].each do |remote, config|
          self.storage[remote.to_sym] = {}
          config.each do |key, val|
            self.storage[remote.to_sym][key.to_sym] = val
          end if config
        end if @yml['storage']
      end

      def set_cache_control!
        @yml['cache_control'].each do |max_age, extensions|
          extensions.each do |extension|
            set_max_age!(extension, max_age)
          end if extensions
        end if @yml['cache_control']
      end

      def set_branch!
        self.branch = []
        @yml['branch'].each do |branch|
          self.branch << branch
        end if @yml['branch']
      end

  end
end
