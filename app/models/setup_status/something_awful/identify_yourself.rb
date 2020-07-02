class SetupStatus::SomethingAwful::IdentifyYourself < SetupStatus::Base
  def finished?
    user.something_awful_id.present?
  end

  def terminal?
    true
  end

  def template
    "authentication/setup/something_awful/identify_yourself"
  end
end
