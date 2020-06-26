require "spec_helper"
require "contests/minefield/explosion"

RSpec.describe Contests::Minefield::Explosion do
  let(:explosion_post) { FactoryBot.build(:post, :with_explosion) }
  let(:posts) { FactoryBot.build_list(:post, 2) + [explosion_post] }

  describe ".find(posts)" do
    it "identifies the explosion post" do
      expect(described_class.find(posts).count).to eq(1)
    end

    it "wraps the post in a #{described_class}" do
      expect(described_class.find(posts).first).to be_a(described_class)
    end
  end

  it "delegates the author to the post" do
    expect(described_class.find(posts).first.author).to eq(explosion_post.author)
  end
end
