class SetupStatus::Overview < SetupStatus::Base
  SEQUENCE = Set.new([
    SetupStatus::Discord,
    SetupStatus::SomethingAwful,
  ]).freeze

  def root?
    true
  end
end
