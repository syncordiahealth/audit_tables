# frozen_string_literal: true
module AuditTables
  class CreateNewAuditTable < Base
    def build
      sync_audit_tables
    end
  end
end
