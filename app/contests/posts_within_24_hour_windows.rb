# frozen_string_literal: true

require "time"
require "sa_client"

module Contests
  class PostsWithin24HourWindows
    THREAD_ID = "3878560"

    def self.print_all
      new.print_all
    end

    def print_all
      start_time = posts.first.timestamp
      end_time = Time.now

      while start_time < end_time
        end_stamp = start_time + (60 * 60 * 24)

        if start_time == posts.first.timestamp || end_stamp < end_time
          count = posts.select { |p| start_time <= p.timestamp && p.timestamp <= end_stamp }.count
          puts "#{start_time.strftime("%F %R")} -> #{end_stamp.strftime("%F %R")}: #{count}"
        end

        start_time += (60 * 10)
      end
    end

  private

    def posts
      @posts ||= SAClient.new(thread_id: THREAD_ID).user_posts
    end
  end
end
