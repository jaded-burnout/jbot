# == Schema Information
#
# Table name: users
#
#  id                       :bigint           not null, primary key
#  admin                    :boolean          default(FALSE), not null
#  discord_access_token     :string
#  discord_refresh_token    :string
#  email                    :string           not null
#  password_digest          :string
#  something_awful_verified :boolean          default(FALSE), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  discord_id               :string
#  something_awful_id       :string
#
class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :discord_id, uniqueness: true

  validates :something_awful_id, presence: true, if: :something_awful_verified?
  validates :something_awful_id, uniqueness: true

  has_many :server_permissions, inverse_of: :user, dependent: :destroy
  has_many :servers, through: :server_permissions, inverse_of: :users
  has_many :servers_with_mod_status,
    -> { where("server_permissions.moderator" => true) },
    through: :server_permissions,
    source: :server,
    inverse_of: :moderators

  has_many :forum_permissions, inverse_of: :user, dependent: :destroy
  has_many :forums, through: :forum_permissions, inverse_of: :users
  has_many :forums_with_mod_status,
    -> { where("forum_permissions.moderator" => true) },
    through: :forum_permissions,
    source: :forum,
    inverse_of: :moderators

  def something_awful_claimed_identity
    return nil if something_awful_id.nil?

    SomethingAwfulUserCache.find_by(something_awful_id: something_awful_id)
  end

  def update_mod_forum_records
    return unless something_awful_id && something_awful_verified
    return unless (sa_identity = something_awful_claimed_identity)

    permissions = sa_identity.forums.map do |forum|
      ForumPermission.find_or_initialize_by(forum: forum).tap do |permission|
        permission.moderator = true
      end
    end

    update!(forum_permissions: permissions)

    sa_identity.forums
  end

  def update_server_records
    return unless discord_id

    self.server_permissions = discord_client.get("users/@me/guilds").map do |guild_info|
      discord_permissions = Discordrb::Permissions.new(guild_info.fetch(:permissions))

      server = Server.find_or_create_by!(discord_id: guild_info.fetch(:id))
      server.update!(name: guild_info.fetch(:name))

      ServerPermission.find_or_create_by!(server: server, user: self).tap do |server_permission|
        server_permission.update!(moderator: discord_permissions.manage_server)
      end
    end

    servers
  end

  def update_discord_id
    user_info = discord_client.get("users/@me")

    if (id = user_info[:id]).blank?
      raise "#{user_info} did not contain an ID"
    else
      update(discord_id: id)
    end
  end

  def discord_assign_token(token)
    assign_attributes(
      discord_access_token: token.token,
      discord_refresh_token: token.refresh_token,
    )
  end

  def revoke_discord
    self.discord_id = self.discord_access_token = self.discord_refresh_token = nil
    save!
  end

  def discord_update_token(token)
    discord_assign_token(token)
    save
  end

  def discord_expired?
    discord_client.expired?
  end

  def discord_force_token_refresh
    discord_client.refresh!(force: true)
  end

private

  def discord_client
    @discord_client ||= DiscordOauth2.new(self)
  end
end
