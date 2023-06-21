# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"
  git_source(:github) { |repo| "https://github.com/#{repo}.git" }
  gem "activesupport", "~> 7.0.0"
  gem "qdrant-ruby"
end

require "active_support"
require "active_support/core_ext/object/blank"
require "qdrant"

client = Qdrant::Client.new(
  url: ENV["QDRANT_URL"]
)

puts client.collections.list
client.collections.create(
    collection_name: "my-test-collection",
    vectors: {},
    shard_number: nil,
    replication_factor: nil,
    write_consistency_factor: nil,
    on_disk_payload: nil,
    hnsw_config: nil,
    wal_config: nil,
    optimizers_config: nil,
    init_from: nil,
    quantization_config: nil
)
puts client.collections.list
puts client.collections.get(collection_name: "my-test-collection")
