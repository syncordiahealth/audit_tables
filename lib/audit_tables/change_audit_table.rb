# frozen_string_literal: true
require_relative './base'

module AuditTables
  class ChangeAuditTable < Base
    attr_accessor :audit_column

    def audit_changes
      columns(audit_table_name).each do |audit_column|
        @audit_column = audit_column

        column_exists?(table_name, audit_column.name) ? change_attribute : remove_attribute
      end
    end

    def change_attribute
      change_column audit_table_name, column_name, column_type, properties_curator if properties_curator.count.positive?
    end

    def execute
      audit_columns
      audit_changes
    end

    def find_column(column)
      columns(table_name).each { |col| @column = col if column.name == col.name }
    end

    # rubocop:disable Metrics/AbcSize:
    def properties_curator
      elements = {}
      find_column(audit_column)

      elements[:limit] = limit unless audit_column.limit == limit
      elements[:precision] = precision unless audit_column.precision == precision
      elements[:scale] = scale unless audit_column.scale == scale
      elements[:null] = null unless audit_column.null == null
      elements[:default] = default unless audit_column.default == default

      elements
    end
    # rubocop:enable Metrics/AbcSize:

    def remove_attribute
      remove_column audit_table_name, audit_column.name unless audit_column.name.include? 'audit'
    end
  end
end
