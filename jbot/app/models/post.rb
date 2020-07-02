# frozen_string_literal: true

require_relative "../../lib/record"

class Post < Record
  ADBOT = "Adbot"
  BOT_USER = "JBot"
  JB_USER = "Jaded Burnout"

  attributes %I[
    author
    id
    text
    timestamp
  ]

  def bot?
    author == BOT_USER
  end

  def user?
    ![
      ADBOT,
      BOT_USER,
      JB_USER,
    ].include?(author)
  end

  def jb?
    author == JB_USER
  end
end
