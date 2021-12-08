class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2 discord]

  has_many :sessions
  has_many :lobbies # , foreign_key: :owner_id
  has_many :game_sessions
  validates :email, uniqueness: false
  validates :username, presence: true, length: { minimum: 2, maximum: 10 }, uniqueness: true

  attr_writer :login

  def login
    @login || username || email
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.username = user.email[/(.+)@/, 1].truncate(10)
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h)
        .where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }])
        .first
    elsif conditions.key?(:username) || conditions.key?(:email)
      where(conditions.to_h).first
    end
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def password_required?
    false
  end

  def only_open_session
    game_sessions.includes(:lobby, lobby: :owner).open.last
  end
end
