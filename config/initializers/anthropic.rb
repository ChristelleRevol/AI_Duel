Anthropic.configure do |config|
  config.access_token = ENV.fetch("ANTHROPIC_API_KEY")
  # # With Rails credentials
  # config.access_token = Rails.application.credentials.dig(:anthropic, :api_key)
end
