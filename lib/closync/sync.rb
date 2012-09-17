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
      push_new_data!
      delete_old_data!
    end

    private

    def push_new_data!
      @local.directory.files.each do |file|
        upload!(file) if upload?(file)
      end
    end

    def delete_old_data!
      # @remote.directory.files.each do |file|
      #   file.delete unless @local.directory.files.head(file)
      # end
    end

    def upload?(file)
      upload = false
      if ( remote_file = @remote.directory.files.head(file.key) )
        if remote_file.last_modified < file.last_modified
          # TODO(wenzowski): check etag to see if file has changed
          upload = true # clobber remote file
        end
      else
        upload = true
      end
      upload
    end

    # If file already exists on remote it will be overwritten.
    def upload!(file)
      @remote.directory.files.create(
        key:            file.key,
        body:           file.body,
        cache_control:  max_age(file),
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
