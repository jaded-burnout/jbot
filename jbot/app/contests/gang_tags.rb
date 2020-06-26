# frozen_string_literal: true

require "sa_client"
require "instant_runoff"

module Contests
  class GangTags
    THREAD_ID = "3903115"

    def self.run_ballot(post_to_thread: false)
      new.run_ballot(post_to_thread: post_to_thread)
    end

    def run_ballot(post_to_thread: false)
      votes_by_category = vote_posts.each_with_object(Hash.new { |h, k| h[k] = [] }) do |post, hash|
        post.text.scan(/##\s+(.*?)$([^#]+)/).each do |category, vote_strings|
          hash[category] << vote_strings.scan(/\s*-\s+(.*?)$/).map(&:first)
        end
      end

      output = StringIO.new
      votes_by_category.each do |category, votes|
        output.puts "Running ballot for #{category}\n\n"

        output.puts InstantRunoff.new(votes: votes).report

        output.puts "-------------------------------\n\n"
      end
      output.rewind

      final_output = output.read
      puts final_output

      if post_to_thread
        print "Posting to thread.."
        client.reply(final_output)
        puts " done."
      end
    end

  private

    def vote_posts
      client.user_and_jb_posts(after: DateTime.new(2019, 11, 14, 9, 31)).select do |post|
        post.text =~ /##\s+\w+/
      end
    end

    def post_to_thread(report)
      client.reply(report)
    end

    def client
      @client ||= SAClient.new(thread_id: THREAD_ID)
    end
  end
end
