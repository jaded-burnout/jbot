class SetupStatus::Discord::IdentifyYourself < SetupStatus::Base
  def finished?
    user.discord_verified?
  end

  def terminal?
    true
  end

  def template
    "authentication/setup/discord/identify_yourself"
  end
end
