# frozen_string_literal: true
require_relative '../../lib/audit_tables'

describe AuditTables::ChangeAuditTable do
  it 'can be' do
    expect(described_class.new('foo')).to be_an_instance_of(AuditTables::ChangeAuditTable)
  end
end
