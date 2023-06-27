# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"
  git_source(:github) { |repo| "https://github.com/#{repo}.git" }
  gem "activesupport", "~> 7.0.0"
  gem "activerecord", "~> 7.0.0"
  gem "qdrant-ruby"
  gem "dotenv"
end

require "active_support"
require "active_support/core_ext/object/blank"
require "active_record"
require "qdrant"
require "logger"
require "dotenv/load"

# Qdrant...
# docker pull qdrant/qdrant
# docker run -p 6333:6333 qdrant/qdrant
# docker run -p 6333:6333 -v $(pwd)/qdrant_storage:/qdrant/storage qdrant/qdrant

qdrant = Qdrant::Client.new(url: ENV["QDRANT_URL"])

qdrant.collections.create(
    collection_name: ENV["COLLECTION_NAME"],
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

# qdrant.points.set_payload(
#   collection_name: ENV["COLLECTION_NAME"],
#   payload: { content: content },
#   points: response.dig("data", 0, "embedding"),
#   filter: {},
#   wait: true,
#   ordering: "asc"
# )

# qdrant.points.upsert(
#   collection_name: ENV["COLLECTION_NAME"],
#   batch: { content: content },
#   wait: true,
#   ordering: "asc"
# )

response = qdrant.points.upsert(
  collection_name: ENV["COLLECTION_NAME"],
  points: [
    {id: 1, vector: [0.05, 0.61, 0.76, 0.74], vector_name: "Sid", payload: {city: "Berlin"}},
    {id: 2, vector: [0.19, 0.81, 0.75, 0.11], vector_name: "Fred", payload: {city: ["Berlin", "London"]}}
  ]
)

puts response.dig("status")
# puts qdrant.points.count(collection_name: ENV["COLLECTION_NAME"])
