class SetupStatus::Base
  def initialize(user, previous_stage: nil)
    @user = user
    @previous_stage = previous_stage
  end

  def finished?
    sequence.all?(&:finished?)
  end

  def sequence
    previous_stage = nil
    ordered_sequence.map { |stage_class|
      stage_class.new(user, previous_stage: previous_stage).tap do |stage|
        previous_stage = stage
      end
    }
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
    previous_stage
    user
  ].freeze
end
