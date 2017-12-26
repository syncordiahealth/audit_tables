# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'audit_tables/version'

Gem::Specification.new do |spec|
  spec.name          = 'audit_tables'
  spec.version       = AuditTables::VERSION
  spec.authors       = ['Syncordia Technologies']
  spec.email         = ['info@syncordiahealth.ie']

  spec.summary       = 'Adds audit tables and triggers for postgres databases'
  spec.description   = 'Adds audit tables and triggers for postgres databases'
  spec.homepage      = 'https://github.com/syncordiahealth/audit_tables'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '>= 5.0.1'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'byebug', '~> 9.0.6'
  spec.add_development_dependency 'faker'
  spec.add_development_dependency 'pg'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rails'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '= 0.48.1'
end
