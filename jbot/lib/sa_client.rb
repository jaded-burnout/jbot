# frozen_string_literal: true

require "web_client"
require "post_parser"

class SAClient
  def initialize(thread_id:)
    @thread_id = thread_id
  end

  def user_posts
    posts.select(&:user?)
  end

  def user_and_jb_posts(after:)
    posts.select do |post|
      next false unless post.timestamp > after

      post.user? || post.jb?
    end
  end

  def bot_posts
    posts.select(&:bot?)
  end

  def reply(text)
    web_client.reply(text)
  end

private

  attr_reader :thread_id

  def web_client
    @web_client ||= WebClient.new(thread_id: thread_id)
  end

  def posts
    @posts ||= begin
      page = web_client.fetch_page
      posts, page_count = PostParser.posts_for_page(page, page_count: true)
      page_number = 2

      until page_number > page_count
        page = web_client.fetch_page(page_number: page_number)
        posts += PostParser.posts_for_page(page)
        page_number += 1
      end

      posts
    end
  end
end
