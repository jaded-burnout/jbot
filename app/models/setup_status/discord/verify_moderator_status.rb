class SetupStatus::Discord::VerifyModeratorStatus < SetupStatus::Base
  def finished?
    user.servers_with_mod_status.any?
  end

  def terminal?
    true
  end

  def template
    "authentication/setup/discord/verify_moderator_status"
  end
end
