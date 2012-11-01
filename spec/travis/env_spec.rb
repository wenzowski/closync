require 'spec_helper'

# https://github.com/travis-ci/travis-build/pull/36
# check if joshk implemented...
describe "Travis CI Environment Variables" do
  it { ENV['TRAVIS_BRANCH'].should == "feature/travis-branch" }
end
