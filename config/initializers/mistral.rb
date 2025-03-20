Mistral.configure do |config|
  config.api_key = ENV.fetch("MISTRAL_API_KEY") { raise "Clé API Mistral manquante !" }
end
