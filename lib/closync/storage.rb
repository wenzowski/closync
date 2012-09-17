require 'fog'

module Closync
  class Storage
    attr_accessor :directory

    # * config (<~object) Closync::Config
    # * opts (<~dict) Options to initialize fog connection.
    #   * :provider (<~string): Options are ['Local', 'AWS', 'Google', 'Rackspace']
    #   * :directory (<~string) Bucket or local directory.
    def initialize(config, opts={})
      dir = opts.delete(:directory)
      case opts[:provider]
      when 'Local'
        opts[:local_root] = Dir.pwd
        @storage = Fog::Storage.new(opts)
      when 'AWS'
        opts[:aws_access_key_id] =
          config.credentials[:aws_access_key_id]
        opts[:aws_secret_access_key] =
          config.credentials[:aws_access_key_id]
        @storage = Fog::Storage.new(opts)
      when 'Google'
        opts[:google_storage_access_key_id] =
          config.credentials[:google_storage_access_key_id]
        opts[:google_storage_secret_access_key] =
          config.credentials[:google_storage_secret_access_key]
        @storage = Fog::Storage.new(opts)
      when 'Rackspace'
        opts[:rackspace_username] =
          config.credentials[:rackspace_username]
        opts[:rackspace_api_key] =
          config.credentials[:rackspace_api_key]
        @storage = Fog::Storage.new(opts)
      else
        raise 'Unsupported provider'
      end

      # Get the requested bucket/directory. Create if missing.
      if d = @storage.directories.get(dir)
        self.directory = d
      else
        @storage.directories.create(key: dir, public: true)
        self.directory = @storage.directories.get(dir)
      end
    end

  end
end
