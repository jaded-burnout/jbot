# frozen_string_literal: true

require_relative "web_fetcher"
require_relative "post_parser"

class SAClient
  DEFAULT_EXCLUDED_USERS = [
    "Adbot",
    "Jaded Burnout",
  ].freeze

  def initialize(thread_id:)
    @web_fetcher = WebFetcher.new(thread_id: thread_id)
  end

  def posts
    filtered_posts
  end

private

  attr_reader :web_fetcher

  def filtered_posts
    unfiltered_posts.reject do |post|
      DEFAULT_EXCLUDED_USERS.include?(post[:name])
    end
  end

  def unfiltered_posts
    page = web_fetcher.fetch_page
    post_array, page_count = PostParser.posts_for_page(page, count: true)

    if page_count > 1
      (2..page_count).each do |page_number|
        page = web_fetcher.fetch_page(page_number: page_number)
        post_array += PostParser.posts_for_page(page)
      end
    end

    return post_array
  end
end
