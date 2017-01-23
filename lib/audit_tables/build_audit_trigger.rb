# frozen_string_literal: true
module AuditTables
  class BuildAuditTrigger < ActiveRecord::Migration
    attr_reader :table_name

    def initialize(table_name)
      @table_name = table_name
    end

    # rubocop:disable Metrics/MethodLength:
    def build
      sequence_name = "seq_audit_#{table_name}"

      execute %{
        DROP TRIGGER IF EXISTS trigger_audit_#{table_name} ON #{table_name};

        CREATE SEQUENCE IF NOT EXISTS #{sequence_name} START 1;

        CREATE OR REPLACE FUNCTION trigger_audit_#{table_name}_func() RETURNS TRIGGER AS $body$
        BEGIN
          IF (TG_OP = 'INSERT') THEN
            INSERT INTO audit_#{table_name}
            SELECT nextval('#{sequence_name}'), 'INSERT', NOW(), *
            FROM #{table_name}
            WHERE id = NEW.id;
          ELSIF (TG_OP = 'UPDATE') THEN
            INSERT INTO audit_#{table_name}
            SELECT nextval('#{sequence_name}'), 'UPDATE', NOW(), *
            FROM #{table_name}
            WHERE id = OLD.id;
          ELSIF (TG_OP = 'DELETE') THEN
            INSERT INTO audit_#{table_name}
            SELECT nextval('#{sequence_name}'), 'DELETE', NOW(), OLD.*;
          END IF;
          RETURN NULL;
        END;
        $body$
        LANGUAGE plpgsql
        SECURITY DEFINER;

        CREATE TRIGGER trigger_audit_#{table_name} AFTER INSERT OR UPDATE OR DELETE ON #{table_name}
        FOR EACH ROW EXECUTE PROCEDURE trigger_audit_#{table_name}_func();
      }
    end
    # rubocop:enable Metrics/MethodLength:
  end
end
