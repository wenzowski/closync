require 'closync/version'
require 'closync/config'
require 'closync/storage'
require 'closync/sync'

##
# The three supported object storage providers are
# Amazon S3, Google Coloud Storage, and Rackspace Cloudfiles.
#
# In addition to loading configuration via yml file (see README.md), Closync
# can also be used programmatically:
#
#   require 'closync'
#
#   config = Closync::Config.new({
#     credentials: {
#       # aws_access_key_id:                  ENV['AWS_ACCESS_KEY_ID'],
#       # aws_secret_access_key:              ENV['AWS_SECRET_ACCESS_KEY'],
#       # google_storage_access_key_id:       ENV['GOOGLE_STORAGE_ACCESS_KEY_ID'],
#       # google_storage_secret_access_key:   ENV['GOOGLE_STORAGE_SECRET_ACCESS_KEY'],
#       rackspace_username:                 ENV['RACKSPACE_USERNAME'],
#       rackspace_api_key:                  ENV['RACKSPACE_API_KEY']
#     },
#     working_dir: '/path/from/root', # defaults to Dir.pwd
#     storage: {
#       local: {
#         provider:   'Local',
#         directory:  'relative/path' # relative to working_dir
#       },
#       remote: {
#         provider:   'Rackspace',    # || 'AWS' || 'Google'
#         directory:  'bucket_name'
#       }
#     },
#     cache_control: {
#       'default'  => (60*60*24*365),
#       '.html'    => (60*5),
#       '.htm'     => (60*5)
#     }
#   })
#
#   Closync::Sync.new(config).push!
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
