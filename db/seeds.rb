# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'

categories = ["research", "image generation", "content generation", "discussion", "mathematics"]
models = ["GPT", "Claude", "Gemini"]

puts "Cleaning DB..."
Vote.destroy_all
Response.destroy_all
Battle.destroy_all
User.destroy_all

puts "Creating users..."
20.times do
  User.create(
    email: Faker::Internet.email,
    pseudo: Faker::Internet.username,
    password: "123456"
  )
end

puts "Creating battles..."
User.first(5).each do |user|
  Battle.create(
    category: categories.sample,
    prompt: Faker::Lorem.paragraphs(number: rand(3..5)).join(" "),
    end_date: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :short),
    user: user
  )
end

puts "Creating responses..."
Battle.all.each do |battle|
  models.each do |model|
    Response.create(
      model: model,
      battle: battle,
      content: Faker::Lorem.paragraphs(number: rand(15..20)).join(" ")
    )
  end
end

puts "Creating votes..."
Battle.all.each do |battle|
  User.all.each do |user|
    Vote.create(
      user: user,
      battle: battle,
      response: battle.responses.sample
    )
  end
end

puts "Updating winners..."
Battle.where('end_date < ?', DateTime.now).each do |battle|
  best_response_id = battle.votes.group(:response_id).count.max_by { |_k, v| v }.first
  battle.update(winner: Response.find(best_response_id).model)
end

puts "Finished! \
Created #{User.count} users |#{Battle.count} battles | #{Response.count} responses | #{Vote.count} votes"
puts "#{Battle.where.not(winner: '').count} battle(s) over"
