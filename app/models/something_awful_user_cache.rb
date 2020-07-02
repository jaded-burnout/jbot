# == Schema Information
#
# Table name: something_awful_user_caches
#
#  id                 :bigint           not null, primary key
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  something_awful_id :string           not null
#
class SomethingAwfulUserCache < ApplicationRecord
  has_and_belongs_to_many :forums, inverse_of: :something_awful_user_caches
end
