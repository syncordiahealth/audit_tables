# frozen_string_literal: true
require_relative './base'

module AuditTables
  class CreateNewAuditTable < Base
    def build
      sync_audit_tables
    end
  end
end
