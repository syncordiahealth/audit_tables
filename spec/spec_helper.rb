# frozen_string_literal: true
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'bundler'

Bundler.setup(:default, :development)

require 'active_record'
require 'active_support'
require 'audit_tables'
require 'rspec'

root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: "#{root}/db/audit_tables.db"
)

RSpec.configure do |config|
end
