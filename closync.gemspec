# -*- encoding: utf-8 -*-
require File.expand_path('../lib/closync/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Alexander Wenzowski"]
  gem.email         = ["alexander@wenzowski.com"]
  gem.summary       = 'A tool for synchronizing cloud storage buckets.'
  gem.description   = <<-EOF
    A tool for deploying complete HTML Apps to S3-compatible object
    storage. Cache-Control max-age headers are set based on file type.
    Closync uses the fog gem to interact with both local and remote storage.
  EOF
  gem.homepage      = "http://github.com/wenzowski/closync"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'closync'
  gem.require_paths = ["lib"]
  gem.version       = Closync::VERSION

  gem.add_dependency('fog')
end
