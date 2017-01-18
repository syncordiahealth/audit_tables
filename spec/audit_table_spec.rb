# frozen_string_literal: true
require 'spec_helper'

class Entity < ActiveRecord::Base
end

class AuditEntity < ActiveRecord::Base
end

describe AuditTables do
  it 'has a version number' do
    expect(AuditTables::VERSION).not_to be nil
  end

  def setup_database
    ActiveRecord::Base.connection.execute('DROP TABLE IF EXISTS audit_entities;')
    ActiveRecord::Base.connection.execute('DROP TABLE IF EXISTS entities;')
    ActiveRecord::Base.connection.create_table(:entities) do |t|
      t.string :name

      t.timestamp
    end
  end

  def create_new_entity(name)
    Entity.create(name: name)
  end

  describe 'Audit Tables' do
    context '.create_audit_table_for' do
      before { setup_database }

      it 'database is audit_tables_test' do
        expect(ActiveRecord::Base.connection_config[:database]).to match(/audit_tables_test/)
      end

      it 'entities table should have an audit table' do
        AuditTables.create_audit_table_for(:entities)

        expect(ActiveRecord::Base.connection.data_source_exists?(:audit_entities)).to eq(true)
      end
    end

    context '.create_audit_tables_for_existing_tables' do
      before do
        setup_database

        AuditTables.configure do |config|
          config.exclude_tables << 'users'
        end
      end

      it 'all tables should have an audit table' do
        AuditTables.create_audit_tables_for_existing_tables

        expect(ActiveRecord::Base.connection.data_source_exists?(:audit_entities)).to eq(true)
      end
    end

    context 'when trigger actions are called' do
      let(:new_name) { Faker::Name.first_name }

      it 'creates new audit_entity records' do
        expect { create_new_entity(new_name) }.to change(AuditEntity, :count).by(1)
      end

      it 'update an entity record' do
        Entity.last.update!(name: new_name)

        expect(AuditEntity.last.name).to eq(new_name)
      end

      it 'creates an audit_entity record when deleting a entity record' do
        expect do
          Entity.last.delete
        end.to change(AuditEntity, :count).by(1)
      end
    end
  end
end
