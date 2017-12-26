# frozen_string_literal: true
require 'active_record'
require_relative '../../lib/audit_tables'

describe AuditTables::CreateAuditTablesForExistingTables do
  let(:connection) { OpenStruct.new(tables: []) }

  before do
    allow(ActiveRecord::Base).to receive(:connection).and_return(connection)
  end

  it 'can be' do
    expect(described_class.new([])).to be_an_instance_of(AuditTables::CreateAuditTablesForExistingTables)
  end
end
