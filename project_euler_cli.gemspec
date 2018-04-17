
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "project_euler_cli/version"

Gem::Specification.new do |spec|
  spec.name          = "project_euler_cli"
  spec.version       = ProjectEulerCli::VERSION
  spec.authors       = ["ecssiah"]
  spec.email         = ["ecssiah@gmail.com"]

  spec.summary       = %q{This is a command line interface for browsing Project Euler.}
  spec.description   = %q{This is a basic command line interface that allows the user to browse through the archive of problems maintained by Project Euler. It also offers a search feature to quickly locate relevant problems.}
  spec.homepage      = "https://github.com/ecssiah/project-euler-cli-app"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.11"

  spec.add_dependency "nokogiri", "~> 1.8"
end
