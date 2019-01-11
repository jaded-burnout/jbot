# frozen_string_literal: true

class PostParser
  class << self
    def posts_for_page(page_html, count: false)
      page = parse(page_html)

      posts = page.css(".post").each_with_object([]).with_index do |(post, array), index|
        author = post.at_css(".author").text

        array << {
          author: author,
          id: post.get("id").sub(/^post/, ""),
          text: post.at_css(".postbody").text,
          timestamp: Time.parse(post.at_css(".postdate").text),
        }
      end

      if count
        [posts, get_page_count(page)]
      else
        posts
      end
    end

  private

    def get_page_count(page)
      page.css(".pages a").last.text.gsub(/\D/, "").to_i
    end

    def parse(page_html)
      Oga.parse_html(page_html)
    end
  end
end
