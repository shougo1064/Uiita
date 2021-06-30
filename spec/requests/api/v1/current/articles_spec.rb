require "rails_helper"

RSpec.describe "Api::V1::Current::Articles", type: :request do
  describe "GET /api/v1/current/articles" do
    subject { get(api_v1_current_articles_path, headers: headers) }

    let(:headers) { current_user.create_new_auth_token }
    let(:current_user) { create(:user) }
    let!(:article1) { create(:article, :published, updated_at: 1.days.ago, user: current_user) }
    let!(:article2) { create(:article, :published, updated_at: 1.months.ago, user: current_user) }
    let!(:article3) { create(:article, :published, user: current_user) }
    let!(:article4) { create(:article, :draft, user: current_user) }
    let!(:article5) { create(:article) }
    it "自分が書いた公開記事を更新順に取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq 3
      expect(res[0]["status"]).to eq "published"
      expect(res[0]["user"]["id"]).to eq current_user.id
      expect(res[0]["user"]["name"]).to eq current_user.name
      expect(res[0]["user"]["email"]).to eq current_user.email
      expect(res.map {|article| article["id"] }).to eq [article3.id, article1.id, article2.id]
      expect(response).to have_http_status(:ok)
    end
  end
end
