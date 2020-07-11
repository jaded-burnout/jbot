# == Schema Information
#
# Table name: servers
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  discord_id :string           not null
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
    name || discord_id
  end
end
