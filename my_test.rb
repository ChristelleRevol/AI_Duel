require 'anthropic'

client = Anthropic::Client.new(access_token: ANTHROPIC_API_KEY)
puts client
