# frozen_string_literal: true

# https://medium.com/@sohaibshaheen/train-chatgpt-with-custom-data-and-create-your-own-chat-bot-using-macos-fb78c2f9646d

# Notes:
#   - vcr doesn't work due to the way the result is presented back to the user

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"
  git_source(:github) { |repo| "https://github.com/#{repo}.git" }
  gem "activesupport", "~> 7.0.0"
  gem "ruby-openai"
  gem "dotenv"
end

require "active_support"
require "active_support/core_ext/object/blank"
require "minitest/autorun"
require "openai"
require "dotenv/load"

client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

client.chat(
  parameters: {
    model: "gpt-3.5-turbo",
    messages: [{ role: "user", content: "Who is Ada Lovelace?"}],
    temperature: 0.7,
    stream: proc do |chunk, _bytesize|
      print chunk.dig("choices", 0, "delta", "content")
    end
  }
)

# response = client.embeddings(
#   parameters: {
#     model: "babbage-similarity",
#     input: "ruby javascript go python"
#   }
# )

# puts response.dig("data", 0, "embedding")
