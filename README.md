[![Build Status](https://secure.travis-ci.org/wenzowski/closync.png)](http://travis-ci.org/wenzowski/closync)

# Closync

Synchronizes local and cloud storage.

## Installation

Add this line to your application's Gemfile:

    gem 'closync'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install closync

## Usage

Closync reads from a yaml configuration file to determine origin and
destination to perform a one-way synchronization.

**.closync.yml**

    credentials:
      google_storage_access_key_id: <%= ENV['GOOGLE_STORAGE_ACCESS_KEY_ID'] %>
      google_storage_secret_access_key: <%= ENV['GOOGLE_STORAGE_SECRET_ACCESS_KEY'] %>
    storage:
      local:
        provider: 'Local'
        directory: 'relative/path'
      remote:
        provider: 'Google'
        directory: 'bucket_name'
    cache_control:
      300:
        - .htm
        - .html
      3600:
        - default

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
