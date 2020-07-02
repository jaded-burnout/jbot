class SetupStatus::Discord < SetupStatus::Base
  SEQUENCE = [
    IdentifyYourself,
    VerifyModeratorStatus,
  ].freeze

  def name
    "Discord"
  end
end
