# frozen_string_literal: true
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => [:style, :spec]

task :style do
  sh 'rubocop'
end
