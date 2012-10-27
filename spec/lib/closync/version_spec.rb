require 'spec_helper'
require 'closync/version'

describe Closync do
  it { Closync::VERSION.should eq('0.1.1'), "Please don't bump the version." }
end
