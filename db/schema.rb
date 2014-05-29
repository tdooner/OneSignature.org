require 'active_record'

ActiveRecord::Schema.define do
  ActiveRecord::Base.connection.tables.each do |table_to_drop|
    drop_table table_to_drop
  end

  create_table :petitions do |t|
    t.string :title, null: false
    t.string :creator_email
  end

  create_table :connected_petitions do |t|
    t.integer :petition_id, null: false
    t.string :type, null: false
    t.string :url, null: false
    t.string :title
    t.string :target
    t.text :description
  end

  create_table :photos do |t|
    t.integer :petition_id
    t.string :url
    t.boolean :cover, default: false
  end
end
