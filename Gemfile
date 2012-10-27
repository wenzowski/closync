source 'https://rubygems.org'

# Specify your gem's dependencies in closync.gemspec
gemspec

group :development, :test do
  gem 'rake'

  gem 'rspec'
  gem 'fuubar'

  unless ENV['TRAVIS']
    gem 'guard-rspec'
    gem 'guard-bundler'

    gem 'ruby-debug', :platform => :mri_18
    gem 'debugger',   :platform => :mri_19

    require 'rbconfig'
    if RbConfig::CONFIG['target_os'] =~ /darwin/i
      gem 'rb-fsevent'
      gem 'growl'
    end
    if RbConfig::CONFIG['target_os'] =~ /linux/i
      gem 'rb-inotify'
      gem 'libnotify'
    end

  end
end

group :development do
  gem 'yard'
  gem 'redcarpet'
end
