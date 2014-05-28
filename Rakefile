require_relative 'environment.rb'

namespace :db do
  desc 'Create the database'
  task :create do
    load 'db/schema.rb'
  end

  desc 'Seed the database'
  task :seed do
    require 'yaml'

    seeds = YAML.load_file('db/seeds.yml')
    seeds["petitions"].each do |p|
      puts Petition.create(p)
    end
  end
end
