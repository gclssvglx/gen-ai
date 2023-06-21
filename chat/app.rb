require "dotenv/load"
require "openai"
require "sinatra"

get "/" do
  erb :index
end

post "/" do
  client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

  response = []
  client.chat(
    parameters: {
      model: "gpt-3.5-turbo",
      messages: [{ role: "user", content: params[:prompt]}],
      temperature: 0.7,
      stream: proc do |chunk, _bytesize|
        response << chunk.dig("choices", 0, "delta", "content")
      end
    }
  )

  @reply = response.join
  erb :index
  # redirect to("/")
end
