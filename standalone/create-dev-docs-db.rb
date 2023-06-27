# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"
  git_source(:github) { |repo| "https://github.com/#{repo}.git" }
  gem "activesupport", "~> 7.0.0"
  gem "activerecord", "~> 7.0.0"
  gem "sqlite3"
  gem "nokogiri"
  gem "dotenv"
end

require "active_support"
require "active_support/core_ext/object/blank"
require "active_record"
require "nokogiri"
require "dotenv/load"

# Using a DB here blows up, it simply becomes too large..!

# ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "dev-docs.db")
# ActiveRecord::Schema.define do
#   create_table :documents, force: true do |t|
#     t.string :url
#     t.text :content
#   end
# end

# class Document < ActiveRecord::Base
# end
file = File.new("test.txt", "w")

Dir.chdir(ENV["DEV_DOCS_BUILD_DIR"])
urls = Dir.glob("**/*/*.html")
puts "Processing [#{urls.count}] files"

urls.each do |url|
  doc = Nokogiri::HTML(File.open(url))
  js1 = "document.body.className = ((document.body.className) ? document.body.className + ' js-enabled' : 'js-enabled');"
  js2 = "window.GOVUKFrontend.initAll()"
  content = doc.at("body").content.gsub("\n", "").gsub(js1, "").gsub(js2, "").gsub(/[\s]{1,}/, " ").strip

  if content.present?
    file.puts "URL: #{url}"
    file.puts "Content: #{content}"
    file.puts "\n"
    # Document.create!(url: url, content: content)
    print "."
  end
end

file.close
# puts "\nCreated [#{Document.count}] records"
