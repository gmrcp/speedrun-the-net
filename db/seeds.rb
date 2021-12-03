# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

GameSession.delete_all
Game.delete_all
Lobby.delete_all
User.delete_all

user = User.new(
  email: 'admin@admin.com',
  password: '123123',
  password_confirmation: '123123',
  username: 'admin'
)
user.save!

admins = %w[Gonçalo, Sérgio, Wellington, James].each do |name|
  user = User.create!(
    email: "#{name}@admin.com",
    password: '123123',
    password_confirmation: '123123',
    username: name
  )
end
byebug

lobby = Lobby.create!(
  owner: user
)

game = Game.create!(
  lobby: lobby,
  start_url: 'Joe_Biden',
  end_url: 'Jazz'
)

admins.each
game_session = GameSession.create!(
  game: game,
  user: user
)
