require "audit_tables/version"

module AuditTables
  BLACK_LISTED_TABLES = [
    'ar_internal_metadata',
    'schema_migrations'
  ].freeze

  def create_audit_table_for(table_name)
    AuditTables::CreateNewAuditTable.new(table_name.to_s).build
  end

  def create_audit_tables_for_existing_tables
    AuditTables::CreateAuditTablesForExistingTables.new.process
  end

  def change_audit_table_for(table_name)
    AuditTables::ChangeAuditTable.new(table_name.to_s).execute
  end

  def build_audit_triggers_for(table_name)
    AuditTables::BuildAuditTrigger.new(table_name.to_s).build
  end

  def rebuild_all_audit_triggers
    tables = ActiveRecord::Base.connection.tables
    tables -= BLACK_LISTED_TABLES

    tables.select { |table| !table.starts_with?('audit_') }.each do |table_name|
      build_audit_triggers_for(table_name)
    end
  end
end
