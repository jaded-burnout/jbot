# == Schema Information
#
# Table name: forums
#
#  id                 :bigint           not null, primary key
#  ancestry           :string
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  something_awful_id :string           not null
#
class Forum < ApplicationRecord
  has_ancestry

  validates :something_awful_id, presence: true, uniqueness: true

  has_many :forum_permissions, inverse_of: :forum, dependent: :destroy
  has_many :users, through: :forum_permissions, inverse_of: :forums
  has_many :moderators,
    -> { where("forum_permissions.moderator" => true) },
    through: :forum_permissions,
    source: :user,
    inverse_of: :forums_with_mod_status

  has_and_belongs_to_many :something_awful_user_caches,
    inverse_of: :forums,
    class_name: "SomethingAwfulUserCache"

  def to_s
    discord_id
  end
end
