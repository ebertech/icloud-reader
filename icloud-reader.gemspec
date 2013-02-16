# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'icloud-reader/version'

Gem::Specification.new do |gem|
  gem.name          = "icloud-reader"
  gem.version       = ICloudReader::VERSION
  gem.authors       = ["Andrew Eberbach"]
  gem.email         = ["andrew@ebertech.ca"]
  gem.description   = %q{Get your CalDAV and CardDAV urls from iCloud}
  gem.summary       = %q{Get your CalDAV and CardDAV urls from iCloud}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_runtime_dependency 'httpclient'
  gem.add_runtime_dependency 'pry'
  gem.add_runtime_dependency 'nokogiri'
  gem.add_runtime_dependency 'clamp'
  gem.add_runtime_dependency 'highline'  
end
