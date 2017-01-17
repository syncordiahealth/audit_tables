# frozen_string_literal: true
Rails.application.routes.draw do
  mount AuditTables::Engine => '/audit_tables'
end
