# frozen_string_literal: true

require_relative "lib/opqr/version"

Gem::Specification.new do |spec|
  spec.name = "opqr"
  spec.version = Opqr::VERSION
  spec.authors = ["intchensc"]
  spec.email = ["intchensc@qq.com"]

  spec.summary = "OPQbot ruby sdk."
  spec.homepage = "https://github.com/intchensc/opqr"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/intchensc/opqr"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'faye-websocket', '~> 0.11.2'
  spec.add_dependency 'minitest', '~> 5.0'
  spec.add_dependency 'terminal-table', '~> 3.0'
  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
