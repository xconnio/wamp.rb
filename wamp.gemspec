# frozen_string_literal: true

require_relative "lib/wamp/version"

Gem::Specification.new do |spec|
  spec.name = "wamp"
  spec.version = Wamp::VERSION
  spec.authors = ["Ismail Akram"]
  spec.email = ["rubyonrails3@gmail.com"]

  spec.summary = "WAMP(Web Application Messaging Protocol) ruby client"
  spec.description = "WAMP(Web Application Messaging Protocol) ruby client"
  spec.homepage = "https://github.com/xconnio/wamp.rb"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.executables << "xconn"
  spec.require_paths = ["lib"]

  spec.add_dependency "cbor", "~> 0.5.9.8"
  spec.add_dependency "ed25519", "~> 1.3"
  spec.add_dependency "msgpack", "~> 1.7.2"
  spec.add_dependency "nio4r", "~> 2.7"
  spec.add_dependency "websocket-driver", "~> 0.7"
  spec.metadata["rubygems_mfa_required"] = "true"
end
