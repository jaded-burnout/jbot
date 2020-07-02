require "token_generator"

class SetupStatus::SomethingAwful::GetVerified < SetupStatus::Base
  def finished?
    user.something_awful_verified?
  end

  def terminal?
    true
  end

  def template
    "authentication/setup/something_awful/get_verified"
  end

  def token
    TokenGenerator.generate_token(
      user_id: user.id,
      action: "sa:identify"
    )
  end
end
