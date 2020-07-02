# == Schema Information
#
# Table name: forum_permissions
#
#  id         :bigint           not null, primary key
#  moderator  :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  forum_id   :bigint           not null
#  user_id    :bigint           not null
#
class ForumPermission < ApplicationRecord
  belongs_to :forum
  belongs_to :user
end
