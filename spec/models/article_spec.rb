# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Article, type: :model do
  context "記事の title, body が指定されているとき" do
    let(:user) { build(:user) }
    let(:article) { build(:article, user: user) }
    it "記事が投稿できる" do
      expect(article).to be_valid
    end
  end

  context "title が指定されていない時" do
    let(:user) { build(:user) }
    let(:article) { build(:article, title: nil) }
    it "記事の投稿に失敗する" do
      expect(article).to be_invalid
      expect(article.errors.details[:title][0][:error]).to eq :blank
    end
  end

  context "body が指定されていない時" do
    let(:user) { build(:user) }
    let(:article) { build(:article, body: nil) }
    it "記事の投稿に失敗する" do
      expect(article).to be_invalid
      expect(article.errors.details[:body][0][:error]).to eq :blank
    end
  end

  context "title の文字数が51文字以上の時" do
    let(:user) { build(:user) }
    let(:article) { build(:article, title: "a" * 51) }
    it "記事の投稿に失敗する" do
      expect(article).to be_invalid
      expect(article.errors.details[:title][0][:error]).to eq :too_long
    end
  end
end
