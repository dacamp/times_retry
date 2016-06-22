# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'times_retry/version'

Gem::Specification.new do |spec|
  spec.name          = "times_retry"
  spec.version       = TimesRetry::VERSION
  spec.authors       = ["David Campbell"]
  spec.email         = ["david@mrcampbell.org"]

  spec.summary       = %q{Retry a code block n times with backoff.}
  spec.homepage      = "https://github.com/dacamp/times_retry"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
