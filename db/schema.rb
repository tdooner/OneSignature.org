require 'active_record'

ActiveRecord::Schema.define do
  ActiveRecord::Base.connection.tables.each do |table_to_drop|
    drop_table table_to_drop
  end

  create_table :petitions do |t|
    t.string :title, null: false
    t.text :description
  end
end
