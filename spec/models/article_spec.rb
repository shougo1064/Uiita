# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  status     :string           default("draft")
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

require "rails_helper"

RSpec.describe Article, type: :model do
  context "記事のタイトルと本文が入力されているとき" do
    let(:article) { build(:article) }
    it "下書き状態の記事が作成できる" do
      expect(article).to be_valid
      expect(article[:status]).to eq "draft"
    end
  end

  context "status が下書き状態のとき" do
    let(:article) { build(:article, :draft) }
    it "記事を下書き状態で作成できる" do
      expect(article).to be_valid
      expect(article[:status]).to eq "draft"
    end
  end

  context "status が公開状態のとき" do
    let(:article) { build(:article, :published) }
    it "記事を公開状態で作成できる" do
      expect(article).to be_valid
      expect(article[:status]).to eq "published"
    end
  end

  context "記事の title が指定されていないとき" do
    let(:article) { build(:article, title: nil) }
    it "記事が投稿できない" do
      expect(article).to be_invalid
      expect(article.errors.messages[:title]).to eq ["can't be blank"]
    end
  end

  context "記事の body が指定されていないとき" do
    let(:article) { build(:article, body: nil) }
    it "記事が投稿できない" do
      expect(article).to be_invalid
      expect(article.errors.messages[:body]).to eq ["can't be blank"]
    end
  end

  context "記事の title の最大文字数が51文字以上のとき" do
    let(:article) { build(:article, title: "a" * 51) }
    it "記事が投稿できない" do
      expect(article).to be_invalid
      expect(article.errors.messages[:title]).to eq ["is too long (maximum is 50 characters)"]
    end
  end
end
