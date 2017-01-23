# frozen_string_literal: true
require_relative '../../lib/audit_tables/create_new_audit_table'

describe AuditTables::CreateNewAuditTable do
  it 'can be' do
    expect(described_class.new('foo')).to be_an_instance_of(AuditTables::CreateNewAuditTable)
  end
end
