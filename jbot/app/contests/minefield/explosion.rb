# frozen_string_literal: true

require "record"
require "forwardable"

module Contests
  module Minefield
    class Explosion < Record
      extend Forwardable

      def_delegator :@post, :author

      attributes %I[
        id
        post
      ]

      class << self
        def find(posts)
          posts.map { |post| new(post) }.reject(&:dud?)
        end
      end

      def initialize(*args)
        super
        @tripped_triggers = parse_tripped_triggers(post.text)
      end

      def dud?
        @tripped_triggers.empty?
      end

      def post_id
        post&.id
      end

    private

      def parse_tripped_triggers(text)
        %w[
          PROBATIONS
          TITLES
          VOUCHER
          WEEK_PROBE
        ].each_with_object({}) do |env, hash|
          next unless ENV[env]

          if (triggers = text.scan(/\b(#{ENV[env]})\b/)).any?
            hash[env.downcase.to_sym] = triggers
          end
        end
      end
    end
  end
end
