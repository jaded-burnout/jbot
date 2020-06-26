# frozen_string_literal: true

require "minefield/explosion"
require "sa_client"
require "templating"

module Contests
  class Minefield
    THREAD_ID = "3878560"

    include Templating

    def initialize
      explosions = Explosion.find(client.user_posts)
      update = Update.find_most_recent(client.bot_posts)
      update.inflate_explosions(explosions)

      @old_explosions = update.explosions
      @new_explosions = explosions - @old_explosions
    end

    def update_to_post?
      @new_triggers.any?
    end

    def post_update
      client.reply(render("minefield_update_post"))
    end

  private

    def client
      @client ||= SAClient.new(thread_id: THREAD_ID)
    end

    def extract_posted_triggers(update_post)
      update_post.links.each_with_object(Set.new) do |link, set|
        if link.text =~ /(?:found a treasure|triggered a mine) by saying (.*)$/
          set.add($1)
        end
      end
    end
  end
end
