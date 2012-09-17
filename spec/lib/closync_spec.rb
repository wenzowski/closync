require 'spec_helper'
require 'closync'

describe Closync do
  it 'should be configured by block' do
    Closync.configure do |config|
      config.credentials = {
        google_storage_access_key_id: ENV['GOOGLE_STORAGE_ACCESS_KEY_ID'],
        google_storage_secret_access_key: ENV['GOOGLE_STORAGE_SECRET_ACCESS_KEY']
      }
      config.local = {provider: 'Local', directory: 'folder/name'}
      config.remote = {provider: 'Google', directory: 'bucket_name'}
      config.branch = ['master']
      config.set_max_age!('default', 3600)
      config.set_max_age!('.htm', 300)
      config.set_max_age!('.html', 300)
    end
    Closync.config.credentials.should_not be_nil
    Closync.config.storage.should_not be_nil
    Closync.config.branch.should_not be_nil
    Closync.config.cache_control.should_not be_nil
  end
end
