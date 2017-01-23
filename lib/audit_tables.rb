# frozen_string_literal: true
require 'active_record'
# include all of the files inside the `lib/audit_tables` folder
Gem.find_files('audit_tables/**/*.rb').each { |path| require path }

module AuditTables
  class << self
    attr_accessor :configuration
  end

  class Configuration
    attr_accessor :exclude_tables

    def initialize
      @exclude_tables = ['ar_internal_metadata', 'schema_migrations']
    end
  end

  def self.config
    self.configuration ||= Configuration.new
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.all_audit_tables
    tables = ActiveRecord::Base.connection.tables
    tables -= config.exclude_tables

    tables
  end

  def self.build_audit_triggers_for(table_name)
    AuditTables::BuildAuditTrigger.new(table_name.to_s).build
  end

  def self.check_for_audit_tables
    messages = []

    all_audit_tables.select { |table| !table.starts_with?('audit_') }.each do |table_name|
      messages << table_name unless all_audit_tables.include? "audit_#{table_name}"
    end

    messages
  end

  def self.create_audit_table_for(table_name)
    AuditTables::CreateNewAuditTable.new(table_name.to_s).build
  end

  def self.create_audit_tables_for_existing_tables
    AuditTables::CreateAuditTablesForExistingTables.new(config.exclude_tables).process
  end

  def self.change_audit_table_for(table_name)
    AuditTables::ChangeAuditTable.new(table_name.to_s).execute
  end

  def self.rebuild_all_audit_triggers
    all_audit_tables.select { |table| !table.starts_with?('audit_') }.each do |table_name|
      build_audit_triggers_for(table_name)
    end
  end
end
