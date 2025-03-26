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
require 'csv'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'battles.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'UTF-8')

models = ["OpenAI", "Claude", "Mistral"]

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

puts "Creating battles & AI responses..."
csv.each do |row|
  user = User.all.sample
  battle = Battle.create(
    prompt: row['prompt'],
    category: row['category'],
    end_date: Faker::Time.between_dates(from: Date.today - 1, to: Date.today + 2, period: :all),
    user: user
  )
  models.each do |model|
    Response.create(
      model: model,
      battle: battle,
      content: row[model],
      token: rand(30..1000)
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
