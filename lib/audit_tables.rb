# frozen_string_literal: true

# include all of the files inside the `lib/audit_tables` folder
Gem.find_files('audit_tables/**/*.rb').each { |path| require path }

module AuditTables
end
