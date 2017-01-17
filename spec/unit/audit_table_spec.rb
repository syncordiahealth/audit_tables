# frozen_string_literal: true
require '../spec_helper'

describe AuditTables do
  it 'has a version number' do
    expect(AuditTables::VERSION).not_to be nil
  end

  describe 'Audit Tables' do
    it 'all tables should have an audit table' do
      tables = ActiveRecord::Base.connection.tables
      tables -= []

      tables.select { |table| !table.starts_with?('audit_') }.each do |table_name|
        audit_table_name = "audit_#{table_name}"
        message = "Audit table: '#{audit_table_name}' does not exist. Use the create_audit_table_for helper."

        expect(ActiveRecord::Base.connection.data_source_exists?(audit_table_name)).to eq(true), message
      end
    end
  end
end
