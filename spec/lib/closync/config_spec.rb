require 'spec_helper'
require 'closync/config'

describe Closync::Config do
  context 'config file exists' do
    subject { Closync::Config.new("#{Dir.pwd}/spec/support/closync.yml") }

    # Fog credentials
    it { subject.credentials.keys.should == ['google_storage_access_key_id', 'google_storage_secret_access_key'] }

    # Remotes to interact with
    it { subject.storage.keys.should == ['local', 'remote'] }
    it { subject.storage['local'].keys.should == ['directory', 'provider'] }
    it { subject.storage['remote'].keys.should == ['directory', 'provider'] }

    # Git branch to check for before performing actions
    it { subject.branch.should == ['master'] }
  end
  context 'config file not found' do
    it 'warns gracefully'
  end
end
