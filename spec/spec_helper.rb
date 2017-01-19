# frozen_string_literal: true
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'active_record'
require 'audit_tables'
require 'byebug'
require 'faker'

ActiveRecord::Base.establish_connection(adapter: 'postgresql', database: 'postgres')

ActiveRecord::Base.connection.execute('DROP DATABASE IF EXISTS audit_tables_test;')
ActiveRecord::Base.connection.execute('CREATE DATABASE audit_tables_test;')
ActiveRecord::Base.connection.disconnect!

ActiveRecord::Base.establish_connection(adapter: 'postgresql', database: 'audit_tables_test')
