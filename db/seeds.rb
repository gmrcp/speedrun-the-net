GameSession.delete_all
Game.delete_all
Message.delete_all
Lobby.delete_all
User.delete_all

# admins = %w[admin goncalo sergio wellington james].map do |name|
#   user = User.create!(
#     email: "#{name}@admin.com",
#     password: '123123',
#     password_confirmation: '123123',
#     username: name
#   )
# end

# lobby = Lobby.create!(
#   owner: admins.sample
# )

# game = Game.create!(
#   lobby: lobby,
#   start_url: 'Joe_Biden',
#   end_url: 'Jazz'
# )
