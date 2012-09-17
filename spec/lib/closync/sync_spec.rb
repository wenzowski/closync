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

  context 'local sync' do
    before(:each) do
      FileUtils.mkdir_p local_dir
      FileUtils.mkdir_p remote_dir
      FileUtils.touch "#{local_dir}/index.html"
      FileUtils.touch "#{local_dir}/pic.jpg"
    end
    after(:each) do
      FileUtils.rm_rf local_dir
      FileUtils.rm_rf remote_dir
    end

    it { lambda {Closync::Sync.new(config)}.should_not raise_error }

    it 'pushes files to remote' do
      File.exists?("#{remote_dir}/index.html").should be_false
      File.exists?("#{remote_dir}/pic.jpg").should be_false
      Closync::Sync.new(config).push!
      File.exists?("#{remote_dir}/index.html").should be_true
      File.exists?("#{remote_dir}/pic.jpg").should be_true
    end
  end

end
