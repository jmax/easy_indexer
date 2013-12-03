# -*- encoding: utf-8 -*-

require "easy_indexer/version"

Gem::Specification.new do |spec|
  spec.name     = "easy_indexer"
  spec.version  = EasyIndexer::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.authors  = ["Juan Maria Martinez Arce"]
  spec.email    = "juan@insignia4u.com"

  spec.require_paths = ["lib"]
  spec.required_rubygems_version = ">= 1.3.6"

  spec.add_dependency "tire", ">= 0.6.1"
end
