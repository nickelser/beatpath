# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "beatpath/version"

Gem::Specification.new do |spec|
  spec.name          = "beatpath"
  spec.version       = Beatpath::VERSION
  spec.authors       = ["Nick Elser"]
  spec.email         = ["nick.elser@gmail.com"]

  spec.summary       = %q{Schulze (Condorcet) voting calculation.}
  spec.homepage      = "https://github.com/nickelser/beatpath"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
