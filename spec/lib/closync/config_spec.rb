require 'spec_helper'
require 'closync/config'

describe Closync::Config do
  context 'no yml config file' do
    subject { Closync::Config.new() }

    it { subject.yml_path.should == "#{Dir.pwd}/.closync.yml" }
    it { subject.yml_exists?.should be_false }

    it { subject.credentials.should == {} }
    it { subject.storage.should == {} }
    it { subject.cache_control.should == {} }

    it { subject.branch.should == [] }
  end

  context 'yml config file missing' do
    let(:yml_path) { "#{Dir.pwd}/.closync.yml" }
    it 'raises error if yml_path does not point to a file' do
      lambda { Closync::Config.new(yml_path: yml_path) }.should raise_error
    end
  end

  context 'yml config file exists' do
    let(:yml_path) { "#{Dir.pwd}/spec/support/closync.yml" }
    subject { Closync::Config.new(yml_path: yml_path) }

    it { subject.yml_path.should == yml_path }
    it { subject.yml_exists?.should be_true }

    # Fog credentials
    it { subject.credentials.keys.should == ['google_storage_access_key_id', 'google_storage_secret_access_key'] }

    # Remotes to interact with
    it { subject.storage.keys.should == ['local', 'remote'] }
    it { subject.storage['local'].keys.should == ['directory', 'provider'] }
    it { subject.storage['remote'].keys.should == ['directory', 'provider'] }

    #  Cache-Control headers
    pending { subject.cache_control.should == {} }

    # Git branch to check for before performing actions
    it { subject.branch.should == ['master'] }
  end
end
