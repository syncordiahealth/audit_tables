# frozen_string_literal: true
require 'base'
require 'build_audit_trigger'
require 'change_audit_table'
require 'create_new_audit_table'
require 'create_audit_tables_for_existing_tables'

module AuditTables
  def self.create_audit_table_for(table_name)
    AuditTables::CreateNewAuditTable.new(table_name.to_s).build
  end

  def self.create_audit_tables_for_existing_tables(options = {})
    AuditTables::CreateAuditTablesForExistingTables.new(options[:excluded_tables]).process
  end

  def self.change_audit_table_for(table_name)
    AuditTables::ChangeAuditTable.new(table_name.to_s).execute
  end

  def self.build_audit_triggers_for(table_name)
    AuditTables::BuildAuditTrigger.new(table_name.to_s).build
  end

  def self.awesome?
    puts 'awesome!!'
  end

  def self.rebuild_all_audit_triggers(options = {})
    tables = ActiveRecord::Base.connection.tables
    tables -= options[:excluded_tables]

    tables.select { |table| !table.starts_with?('audit_') }.each do |table_name|
      build_audit_triggers_for(table_name)
    end
  end
end
