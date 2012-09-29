require 'spec_helper'

describe "Travis CI Environment Variables" do
  it { ENV['TRAVIS_BRANCH'].should == "feature/travis-branch" }
end
