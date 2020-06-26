module Contests
  module Minefield
    class Update
      class << self
        def find_most_recent(posts)
          update_post = posts
            .select { |p| p.text.include?("Update!") }
            .sort_by(&:timestamp)
            .last

          new(update_post)
        end
      end

      def initialize(post)
        @post = post


      end

      def post_id
        @post&.id
      end
    end
  end
end
