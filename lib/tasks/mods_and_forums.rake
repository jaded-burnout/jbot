desc "Tasks related to mods and forums"
namespace :mods_and_forums do
  desc "Import"
  task import: :environment do
    require Rails.root + "jbot/lib/sa_client"

    mods_and_forums = SAClient.fetch_mods_and_forums(Rails.root + ".cookies").map(&:deep_symbolize_keys)

    def build_tree(root, parent = nil)
      return unless root.has_key?(:id)

      forum = Forum.find_or_create_by!(something_awful_id: root.fetch(:id))
      root.fetch(:sub_forums).each { |s| build_tree(s, forum) }
      forum.update!(
        name: root.fetch(:title),
        parent: parent,
        something_awful_user_caches: root.fetch(:moderators).map { |mod_info|
          cache = SomethingAwfulUserCache.find_or_create_by!(something_awful_id: mod_info.fetch(:userid))
          cache.update!(name: mod_info.fetch(:username))
          cache
        }
      )
    end

    mods_and_forums.each do |forum_info|
      build_tree(forum_info)
    end
  end
end
