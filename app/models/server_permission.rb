# == Schema Information
#
# Table name: server_permissions
#
#  id         :bigint           not null, primary key
#  moderator  :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  server_id  :bigint           not null
#  user_id    :bigint           not null
#
class ServerPermission < ApplicationRecord
  belongs_to :server
  belongs_to :user
end
