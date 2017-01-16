# frozen_string_literal: true
module AuditTables
  class CreateAuditTablesForExistingTables < Base
    attr_reader :klasses

    def initialize
      @klasses = ActiveRecord::Base.connection.tables
      @klasses -= Module::BLACK_LISTED_TABLES
    end

    def process
      klasses.each do |klass|
        AuditTables::BuildAuditTrigger.new(klass).build
        @table_name = klass
        @klass = klass.classify.safe_constantize
        @audit_table_name = "audit_#{klass}"
        sync_audit_tables
      end
    end
  end
end
