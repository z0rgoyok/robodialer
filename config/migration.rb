#!/usr/bin/env ruby
require 'yaml'
require 'rubygems'
require 'active_record'

# A migration script uses a database configuration and creates tables
# very conveniently in a database-agnostic way. Below, add any customizations
# to the sample schema or leave it as-is. When done, type "rake migrate" to
# have this schema generated.

ActiveRecord::Base.establish_connection YAML.load_file('config/database.yml')

class CreateCustomers < ActiveRecord::Migration
  # Available column types are :primary_key, :string, :text, :integer,
  # :float, :datetime, :timestamp, :time, :date, :binary, and :boolean
  def self.up
    create_table :customers do |t|
      t.column :phone, :string
      t.column :status, :string
    end
  end

  def self.down
    drop_table :customers
  end
end

class CreateCallAttempts < ActiveRecord::Migration
  # Available column types are :primary_key, :string, :text, :integer,
  # :float, :datetime, :timestamp, :time, :date, :binary, and :boolean
  def self.up
    create_table :call_attempts do |t|
      t.column :result, :string
      t.column :attempted_at, :datetime
      t.column :customer_id, :integer
    end
  end

  def self.down
    drop_table :call_attempts
  end
end

CreateCustomers.up
CreateCallAttempts.up
