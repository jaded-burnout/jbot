class SetupStatus::Base
  def initialize(user)
    @user = user
  end

  def finished?
    sequence.all?(&:finished?)
  end

  def sequence
    ordered_sequence.map { |s| s.new(user) }
  end

  def terminal?
    false
  end

  def root?
    false
  end

  def ordered?
    self.class::SEQUENCE.is_a?(Array)
  end

  def ==(other)
    other.class.name == self.class.name
  end

private

  def ordered_sequence
    ordered? ? self.class::SEQUENCE : self.class::SEQUENCE.sort_by(&:name)
  end

  attr_reader *%I[
    user
  ].freeze
end
