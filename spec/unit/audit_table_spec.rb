# frozen_string_literal: true
require '../spec_helper'

class Company < ActiveRecord::Base
end

describe AuditTables do
  it 'has a version number' do
    expect(AuditTables::VERSION).not_to be nil
  end

  describe 'Audit Tables' do
    before do
      ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'companies'")
      ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'audit_companies'")
      ActiveRecord::Base.connection.create_table(:companies) do |t|
        t.string :name
        
        t.timestamp
      end
    end

    it 'all tables should have an audit table' do
      tables = ActiveRecord::Base.connection.tables
      tables -= []

      puts "tables ===> #{ActiveRecord::Base.connection.tables}"

      tables.select { |table| !table.starts_with?('audit_') }.each do |table_name|
        AuditTables.create_audit_table_for(table_name)
        audit_table_name = "audit_#{table_name}"
        message = "Audit table: '#{audit_table_name}' does not exist. Use the create_audit_table_for helper."

        expect(ActiveRecord::Base.connection.data_source_exists?(audit_table_name)).to eq(true), message
      end
    end
  end
end
