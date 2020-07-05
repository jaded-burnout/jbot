desc "Tasks related to mods and forums"
namespace :mods_and_forums do
  desc "Import"
  task import: :environment do
    mods_and_forums = SomethingAwful::Client.fetch_mods_and_forums(Rails.root + ".cookies").map(&:deep_symbolize_keys)

    def build_tree(root, parent = nil)
      return unless root.has_key?(:id)

      forum_name = root.fetch(:title)

      puts "Importing forum #{forum_name}"

      forum = Forum.find_or_create_by!(something_awful_id: root.fetch(:id))
      root.fetch(:sub_forums).each { |s| build_tree(s, forum) }
      forum.update!(
        name: forum_name,
        parent: parent,
        something_awful_user_caches: root.fetch(:moderators).map { |mod_info|
          mod_name = mod_info.fetch(:username)
          puts "-- Importing mod #{mod_name}"

          cache = SomethingAwfulUserCache.find_or_create_by!(something_awful_id: mod_info.fetch(:userid))
          cache.update!(name: mod_name)
          cache
        }
      )
    end

    mods_and_forums.each do |forum_info|
      build_tree(forum_info)
    end
  end

  desc "Check profiles"
  task check_profiles: :environment do
    User
      .where(something_awful_verified: false)
      .where.not(something_awful_id: nil)
      .each do |user|
        user.update!(something_awful_id: nil) unless user.something_awful_claimed_identity

        user_name = user.something_awful_claimed_identity.name

        puts "Verifying #{user_name}"

        status = SetupStatus::SomethingAwful::GetVerified.new(user)

        profile = SomethingAwful::Client.fetch_profile(Rails.root + ".cookies",
          something_awful_id: user.something_awful_id,
        )

        if profile.include?(status.token)
          puts "-- #{user_name} verified!"
          user.update!(something_awful_verified: true)

          if (assigned_forums = user.update_mod_forum_records)
            puts "-- Assigning mod permissions to #{assigned_forums.pluck(:name).to_sentence}"
          end
        elsif user.updated_at < 1.day.ago
          puts "-- #{user_name}'s request is stale, deleting"
          user.update!(something_awful_id: nil)
        end
      end
  end
end
