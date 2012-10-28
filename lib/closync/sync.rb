require 'closync/storage'

module Closync
  class Sync

    def initialize(config)
      @config = config
      raise 'Local directory not configured' unless config.local
      raise 'Remote directory not configured' unless config.remote
      @local = Closync::Storage.new(config, config.local)
      @remote = Closync::Storage.new(config, config.remote)
    end

    def push!
      @local.directory.files.each do |local_file|
        upload!(local_file) if stale_on_remote?(local_file)
      end
      @remote.directory.files.each do |remote_file|
        remote_file.destroy unless exists_locally?(remote_file)
      end
    end

    private


    def exists_locally?(remote_file)
      return true if @local.directory.files.head(remote_file.key)
      false
    end

    # TODO(wenzowski): local_file.should.respond_to?(:content_md5)
    def stale_on_remote?(local_file)
      remote_file = @remote.directory.files.head(local_file.key)
      return true unless remote_file # file is missing from remote, therefore stale
      if remote_file.respond_to?(:content_md5) && local_file.respond_to?(:content_md5)
        (
          ( remote_file.content_length != local_file.content_length ) &&
          ( remote_file.content_md5 != local_file.content_md5 )
        )
      else
        true # if we don't know, upload anyway
      end
    end

    # If file already exists on remote it will be overwritten.
    def upload!(local_file)
      @remote.directory.files.create(
        key:            local_file.key,
        body:           local_file.body,
        cache_control:  "public, max-age=#{max_age(local_file)}",
        public:         true
      )
    end

    def max_age(file)
      @config.max_age( extension(file) )
    end

    def extension(file)
      /(\.\w+)$/.match(file.key)[0]
    end
  end
end
