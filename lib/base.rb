# frozen_string_literal: true
module AuditTables
  class Base < ActiveRecord::Migration[5.0]
    attr_accessor :audit_table_name, :column, :klass, :table_name

    def initialize(table_name)
      @table_name = table_name
      @audit_table_name = "audit_#{table_name}"
      @klass = table_name.classify.safe_constantize
    end

    private

    def add_new_column
      if properties.empty?
        add_column audit_table_name, column.name, column_type
      else
        add_column audit_table_name, column.name, column_type, properties
      end
    end

    def audit_columns
      columns(table_name).each do |column|
        @column = column

        add_new_column unless column_exists?(audit_table_name, column.name)
      end
    end

    def sync_audit_tables
      create_audit_table unless table_exists?
      audit_columns
    end

    def column_exists?(table_name, column_name)
      ActiveRecord::Base.connection.column_exists?(table_name, column_name)
    end

    def column_name
      column.name
    end

    def column_type
      column.type
    end

    def columns(table_name)
      ActiveRecord::Base.connection.columns(table_name)
    end

    def create_audit_table
      create_table audit_table_name, id: false do |t|
        t.integer :audit_id, null: false
        t.string :audit_operation, null: false
        t.datetime :audit_timestamp, null: false
      end
      
      add_column audit_table_name, :id, klass.columns_hash['id'].type
    end

    def default
      column.default
    end

    def limit
      column.limit
    end

    def null
      column.null
    end

    def precision
      column.precision
    end

    def properties
      elements = {}

      elements[:limit] = limit unless limit.nil?
      elements[:precision] = precision unless precision.nil?
      elements[:scale] = scale unless scale.nil?
      elements[:default] = default unless default.nil?
      elements[:null] = null

      elements
    end

    def scale
      column.scale
    end

    def table_exists?
      ActiveRecord::Base.connection.data_source_exists? audit_table_name
    end
  end
end
