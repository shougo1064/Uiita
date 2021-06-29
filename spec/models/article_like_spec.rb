# == Schema Information
#
# Table name: article_likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_article_likes_on_article_id  (article_id)
#  index_article_likes_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe ArticleLike, type: :model do
  context "ユーザーと記事の id が存在するとき" do
    let(:user) { create(:user) }
    let(:article) { create(:article) }
    let(:article_like) { build(:article_like, user_id: user.id, article_id: article.id) }
    it "いいねできる" do
      expect(article_like).to be_valid
    end
  end

  context "ユーザーの id が存在しないとき" do
    let(:article_like) { build(:article_like, user_id: nil, article_id: article.id) }
    let(:article) { create(:article) }
    fit "いいねできない" do
      expect(article_like).to be_invalid
      expect(article_like.errors.messages[:user]).to eq ["must exist"]
      expect(article_like.errors.messages[:user_id]).to eq ["can't be blank"]
    end
  end

  context "記事の id が存在しないとき" do
    let(:article_like) { build(:article_like, user_id: user.id, article_id: nil) }
    let(:user) { create(:user) }
    it "いいねできない" do
      expect(article_like).to be_invalid
      expect(article_like.errors.messages[:article]).to eq ["must exist"]
      expect(article_like.errors.messages[:article_id]).to eq ["can't be blank"]
    end
  end
end
