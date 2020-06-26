# == Schema Information
#
# Table name: servers
#
#  id         :bigint           not null, primary key
#  discord_id :string           not null
#  user_id    :bigint           not null
#
class Server < ApplicationRecord
  validates :discord_id, presence: true, uniqueness: true

  belongs_to :user, inverse_of: :servers

  def to_s
    discord_id
  end
end
