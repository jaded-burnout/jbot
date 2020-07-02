# == Schema Information
#
# Table name: servers
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  discord_id :string           not null
#  user_id    :bigint           not null
#
class Server < ApplicationRecord
  validates :discord_id, presence: true, uniqueness: true

  has_many :server_permissions, inverse_of: :server, dependent: :destroy
  has_many :users, through: :server_permissions, inverse_of: :servers
  has_many :moderators,
    -> { where("server_permissions.moderator" => true) },
    through: :server_permissions,
    source: :user,
    inverse_of: :servers_with_mod_status

  def to_s
    discord_id
  end
end
