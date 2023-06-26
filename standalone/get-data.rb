# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"
  git_source(:github) { |repo| "https://github.com/#{repo}.git" }
  gem "activesupport", "~> 7.0.0"
  gem "nokogiri"
end

require "active_support"
require "active_support/core_ext/object/blank"
require "nokogiri"

puts Dir.pwd
Dir.chdir("../../govuk-developer-docs/build")
puts Dir.pwd
files = Dir.glob("**/*/*.html")
puts files.inspect
puts files.count

# files.each do |file|
#   text = Nokogiri::HTML(file)
#   puts text 
# end 

document = Nokogiri::HTML(File.open("../../govuk-developer-docs/build/index.html"))
puts document


text = []
document.traverse do |node|
  next unless node.is_a?(Nokogiri::XML::Element)

  text << node.text.gsub("\n", "").gsub(/[\s]{1,}/, " ").strip
end

puts text.reject { |t| t.empty? }.uniq.inspect