require "spec_helper"
require "contests/minefield/update"

RSpec.describe Contests::Minefield::Update do
  let(:previous_update_post_text) {
    %{
      :siren: Update! :siren:

      <a href="https://forums.somethingawful.com/showthread.php?goto=post&postid=#{new_sixer.post_id}>#{new_sixer.author} caught a sixer to the face</url>
      <a href="https://forums.somethingawful.com/showthread.php?goto=post&postid=#{new_title.post_id}>#{new_title.author} found a buried title change certificate</url>
      <a href="https://forums.somethingawful.com/showthread.php?goto=post&postid=#{new_cash_prize.post_id}>#{new_cash_prize.author} fell into a pot of gold!</url>

      And previously..

      <a href="https://forums.somethingawful.com/showthread.php?goto=post&postid=#{old_title.post_id}>#{old_title.author} found a buried title change certificate</url>
      <a href="https://forums.somethingawful.com/showthread.php?goto=post&postid=#{old_seven_day.post_id}>#{old_seven_day.author} lost a leg and is out for a week</url>
    }
  }

  let(:previous_update_post) {
    FactoryBot.build(:post)
  }

  let(:most_recent_update_post) {
    FactoryBot.build(:post, text: previous_update_post_text)
  }

  let(:new_sixer) { FactoryBot.build(:explosion, :sixer) }
  let(:new_title) { FactoryBot.build(:explosion, :title) }
  let(:new_cash_prize) { FactoryBot.build(:explosion, :cash_prize) }
  let(:old_title) { FactoryBot.build(:explosion, :title) }
  let(:old_seven_day) { FactoryBot.build(:explosion, :seven_day) }

  let(:user_posts) {
    [
      old_title.post,
      old_seven_day.post,
      new_sixer.post,
      new_title.post,
      new_cash_prize.post,
    ]
  }

  let(:bot_posts) {
    [
      previous_update_post,
      most_recent_update_post,
    ]
  }

  describe ".find_most_recent(bot_posts)" do
    it "identifies the most recent update post" do
      expect(described_class.find_most_recent(bot_posts).post_id).to eq(most_recent_update_post.id)
    end

    it "wraps the post in a #{described_class}" do
      expect(described_class.find_most_recent(bot_posts)).to be_a(described_class)
    end
  end

  it "parses an update post into new and old explosions" do
    update = described_class.find_most_recent(posts)

    expect(update.old_explosions).to match_array(old_title, old_seven_day)
    expect(update.new_explosions).to match_array(new_sixer, new_title, new_cash_prize)
  end
end
