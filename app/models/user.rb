# == Schema Information
#
# Table name: users
#
#  id                       :bigint           not null, primary key
#  admin                    :boolean          default(FALSE), not null
#  discord_verified         :boolean          default(FALSE), not null
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

  validates :discord_id, presence: true, if: :discord_verified?
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
      ForumPermission.find_or_initialize_by(forum_id: forum.id).tap do |permission|
        permission.moderator = true
      end
    end

    update!(forum_permissions: permissions)

    sa_identity.forums
  end
end
