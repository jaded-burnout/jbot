class SetupStatus::SomethingAwful::VerifyModeratorStatus < SetupStatus::Base
  def finished?
    previous_stage.finished? && user.forums_with_mod_status.any?
  end

  def terminal?
    true
  end

  def template
    "authentication/setup/something_awful/verify_moderator_status"
  end
end
