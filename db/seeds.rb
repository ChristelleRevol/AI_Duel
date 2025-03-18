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

puts "Cleaning DB..."
User.destroy_all
Battle.destroy_all
Vote.destroy_all
puts "Creating users..."
User.create(
  email: Faker::Internet.email,
  pseudo: Faker::Internet.username,
  password: "123456"
)
puts "Creating battles..."
Battle.create(
  category: categories.sample,
  content_prompt: Faker::Lorem.paragraph(sentence_count: rand(2..5)),
  status: Faker::Boolean.boolean(true_ratio: 0.2),
  end_date: Faker::Date.between(from: 2.days.ago, to: 1.days.from_now),
  winner: "",
  user: ""
)
puts "Creating votes..."
Vote.create(
  user: "",
  battle: "",
  response: ""
)
puts "Creating responses..."
Response.create(
  model: "",
  battle: "",
  content: Faker::Lorem.paragraph(sentence_count: rand(5..10))
)
puts "Finished!\n
Created #{User.count} users |#{Battle.count} battles | #{Response.count} responses | #{Vote.count} votes"
