require 'spec_helper'
require 'closync/storage'
require 'closync/config'

describe Closync::Storage do
  let(:yml_path) { "#{Dir.pwd}/spec/support/closync.yml" }
  let(:dir) { SecureRandom.hex }
  let(:config) { Closync::Config.new(yml_path: yml_path) }

  context 'local storage' do
    # DIRTY HACK: Fog's Local Storage is not mocked.
    before(:each) do
      FileUtils.rm_rf 'tmp'
      FileUtils.mkdir 'tmp'
    end
    subject { Closync::Storage.new(Closync::Config.new, provider: 'Local', directory: "tmp/#{dir}") }
    it { subject.directory.class.should be(Fog::Storage::Local::Directory) }
    it { subject.directory.key.should eq("tmp/#{dir}") }
  end

  context 'google storage' do
    # WARNING: THESE TESTS CREATE BUCKETS ON GOOGLE STORAGE
    # subject { Closync::Storage.new(config, provider: 'Google', directory: dir) }
    # it { subject.directory.class.should be(Fog::Storage::Google::Directory) }
    # it { subject.directory.key.should == dir }
  end

end
