$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "easy_indexer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "easy_indexer"
  s.version     = EasyIndexer::VERSION
  s.authors     = ["Juan Maria Martinez Arce"]
  s.email       = ["juan@insignia4u.com"]
  s.homepage    = "https://github.com/jmax/easy_indexer"
  s.summary     = "Super simple ElasticSearch integration for Rails"
  s.description = "Super simple ElasticSearch integration for Rails"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", ">= 4.2.0"
  s.add_dependency "elasticsearch", ">= 1.0.15"
  s.add_dependency "hashie"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails",      '~> 3.0'
  s.add_development_dependency "database_cleaner", ">= 1.5.1"
  s.add_development_dependency "shoulda-matchers", '~> 3.1'
end
