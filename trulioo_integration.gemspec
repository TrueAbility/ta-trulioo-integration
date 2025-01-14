lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "trulioo_integration/version"

Gem::Specification.new do |spec|
  spec.name          = "trulioo_integration"
  spec.version       = TruliooIntegration::VERSION
  spec.authors       = ["Daniel Zepeda "]
  spec.email         = ["daniel.zepeda@trueability.com"]

  spec.summary       = %q{Encapsulate  [Trulioo's](https://developer.trulioo.com) API.}

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  spec.add_dependency "awesome_print"
  spec.add_dependency "httparty"
end
