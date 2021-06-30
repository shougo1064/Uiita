require "rails_helper"

RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  let(:headers) { current_user.create_new_auth_token }
  let(:current_user) { create(:user) }
  describe "GET /api/v1/articles/drafts" do
    subject { get(api_v1_articles_drafts_path, headers: headers) }

    let!(:article1) { create(:article, :draft, user: current_user, updated_at: 1.days.ago) }
    let!(:article2) { create(:article, :draft, user: current_user, updated_at: 3.days.ago) }
    let!(:article3) { create(:article, :draft, user: current_user) }
    let!(:article4) { create(:article, :published, user: current_user) }
    let!(:article5) { create(:article, :draft) }
    it "自分が書いた下書きの一覧のみが取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(res.length).to eq 3
      expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
      expect(res[0].keys).to eq ["id", "title", "updated_at", "status", "user"]
    end
  end

  describe "GET /api/v1/articles/drafts/:id" do
    subject { get(api_v1_articles_draft_path(article.id), headers: headers) }

    context "指定した id の記事が存在して" do
      context "対象の記事が自分が書いた下書き記事のとき" do
        let(:article) { create(:article, :draft, user: current_user) }
        it "記事の詳細を取得できる" do
          subject
          res = JSON.parse(response.body)
          expect(res["id"]).to eq article.id
          expect(res["title"]).to eq article.title
          expect(res["body"]).to eq article.body
          expect(res["status"]).to eq article.status
          expect(res["updated_at"]).to be_present
          expect(res["user"]["id"]).to eq article.user.id
          expect(response).to have_http_status(:ok)
          expect(res["user"].keys).to eq ["id", "name", "email"]
        end
      end

      context "対象の記事が他のユーザーが書いた下書き記事のとき" do
        let(:article) { create(:article, :draft) }
        it "エラーする" do
          expect { subject }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end
end
