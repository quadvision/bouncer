$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bouncer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bouncer"
  s.version     = Bouncer::VERSION
  s.authors     = ["Berlimioz"]
  s.email       = ["berlimioz@gmail.com"]
  s.homepage    = "https://github.com/quadvision/bouncer"
  s.summary     = "Path oriented authorization for Rails applications"
  s.description = "Path oriented authorization for Rails applications"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/*"]

  s.add_dependency "activesupport", ">= 3.0.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rails"
  s.add_development_dependency "better_errors"
  s.add_development_dependency "binding_of_caller"
  s.add_development_dependency "web-console"
  s.add_development_dependency "rspec"
end
