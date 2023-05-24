# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fintecture/version'

Gem::Specification.new do |spec|
  spec.name          = 'fintecture'
  spec.version       = Fintecture::VERSION
  spec.authors       = ['Fintecture']
  spec.email         = ['support@fintecture.com']

  spec.summary       = 'SDK to allow easy and secure access to bank account data and payment initiation with Fintecture.'
  spec.description   = 'Our APIs allow easy and secure access to bank account data and payment initiation. The account data accessible are account holder\'s personal information, account balances, transaction history and much more. The available payment methods depend on the banks implementation but typically are domestic transfers, SEPA credit transfer, instant SEPA credit transfer, fast payment scheme, and SWIFT international payments.'
  spec.homepage      = 'http://fintecture.com'
  spec.license       = 'GPL-3.0'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata["allowed_push_host"] = 'http://mygemserver.com'

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/Fintecture/fintecture-sdk-ruby'
    # spec.metadata["changelog_uri"] = spec.homepage
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_dependency 'faraday'
end
