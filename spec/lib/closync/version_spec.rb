require 'spec_helper'
require 'closync/version'

describe Closync do
  it { Closync::VERSION.should eq('0.1.0'), "Please don't bump the version." }
end
