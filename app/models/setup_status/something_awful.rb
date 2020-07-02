class SetupStatus::SomethingAwful < SetupStatus::Base
  SEQUENCE = [
    IdentifyYourself,
    GetVerified,
    VerifyModeratorStatus,
  ].freeze

  def name
    "SomethingAwful"
  end
end
