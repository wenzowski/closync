require 'spec_helper'
require 'closync/sync'
require 'closync/config'

describe Closync::Storage do
  let(:dir) { SecureRandom.hex }
  let(:local_dir) { "tmp/local/#{dir}" }
  let(:remote_dir) { "tmp/remote/#{dir}" }

  let(:yml_path) { "#{Dir.pwd}/spec/support/closync.yml" }
  let(:config) {
    config = Closync::Config.new(yml_path: yml_path)
    config.local = { provider: 'Local', directory: local_dir }
    config.remote = { provider: 'Local', directory: remote_dir }
    config
  }

  before(:each) do
    FileUtils.mkdir_p local_dir
    FileUtils.mkdir_p remote_dir
    FileUtils.touch "#{remote_dir}/missing.html"
    FileUtils.touch "#{remote_dir}/stale.html"
    FileUtils.touch "#{local_dir}/index.html"
    FileUtils.touch "#{local_dir}/pic.jpg"
    File.open("#{local_dir}/stale.html", 'w') {|f| f.write('new data') }
  end
  after(:each) do
    FileUtils.rm_rf local_dir
    FileUtils.rm_rf remote_dir
  end

  it { lambda {Closync::Sync.new(config)}.should_not raise_error }

  context 'before sync' do
    its 'new files exist locally' do
      File.exists?("#{local_dir}/index.html").should be_true
      File.exists?("#{local_dir}/pic.jpg").should be_true
    end
    its 'new files do not exist on remote' do
      File.exists?("#{remote_dir}/index.html").should be_false
      File.exists?("#{remote_dir}/pic.jpg").should be_false
    end
    its 'missing files do not exist locally' do
      File.exists?("#{local_dir}/missing.html").should be_false
    end
    its 'missing files exist on remote' do
      File.exists?("#{remote_dir}/missing.html").should be_true
    end
    its 'stale files are a different size on remote' do
      File.size("#{remote_dir}/stale.html").should_not == File.size("#{local_dir}/stale.html")
    end
  end

  context 'after sync' do
    before(:each) { Closync::Sync.new(config).push! }
    its 'new files exist locally' do
      File.exists?("#{local_dir}/index.html").should be_true
      File.exists?("#{local_dir}/pic.jpg").should be_true
    end
    its 'new files exist on remote' do
      File.exists?("#{remote_dir}/index.html").should be_true
      File.exists?("#{remote_dir}/pic.jpg").should be_true
    end
    its 'missing files do not exist locally' do
      File.exists?("#{local_dir}/missing.html").should be_false
    end
    its 'missing files do not exist on remote' do
      File.exists?("#{remote_dir}/missing.html").should be_false
    end
    its 'stale files are the same size on remote' do
      File.size("#{remote_dir}/stale.html").should == File.size("#{local_dir}/stale.html")
    end
  end

end
