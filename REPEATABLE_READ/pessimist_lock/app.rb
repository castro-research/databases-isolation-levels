# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  # gem "sqlite3"
  # Activate the gem you are reporting the issue against.
  gem "activerecord", "7.1.2"
  gem "pg"
end

require "active_record"
require "minitest/autorun"
require "logger"

# This connection will do for database-independent bug reports.
# ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  encoding: "unicode",
  database: ENV["DB_NAME"],
  username: "postgres",
  password: "",
  host: ENV["DB_HOST"],
)


ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  create_table :books, id: :serial, force: true do |t|
    t.integer :readers_count, default: 0
  end
end


class Book < ActiveRecord::Base
  def update_counter(value)
    self.update(readers_count: [value, self.readers_count].compact.max)
  end
end

class BugTest < Minitest::Test
    def test_bug_readatable_read
        book = Book.create!
        book.readers_count = 10
        book.save!

        threads = []
        
        2.times do |i|
            threads << Thread.new do
                ActiveRecord::Base.connection_pool.with_connection do
                    book = Book.find(book.id)
                    count = i % 2 == 0 ? 50 : 20
                    puts "Thread #{i} - book.readers_count: #{book.readers_count} - count: #{count}"
                    book.update_counter(count)
                    book.save!
                end
            end
        end

        threads.each(&:join)
        
        updated_book = Book.find(book.id)
        puts "updated_book.readers_count: #{updated_book.readers_count}"
        refute_equal(50, updated_book.readers_count)
    end

    def test_readatable_read_with_pessimist_lock
        book = Book.create!
        book.readers_count = 10
        book.save!

        threads = []
        
        2.times do |i|
            threads << Thread.new do
                ActiveRecord::Base.connection_pool.with_connection do
                    book = Book.find(book.id)
                    count = i % 2 == 0 ? 50 : 20
                    puts "Thread #{i} - book.readers_count: #{book.readers_count} - count: #{count}"
                    book.with_lock do
                        book.update_counter(count)
                        book.save!
                    end
                end
            end
        end

        threads.each(&:join)
        
        updated_book = Book.find(book.id)
        puts "updated_book.readers_count: #{updated_book.readers_count}"
        assert_equal(50, updated_book.readers_count)
    end
end