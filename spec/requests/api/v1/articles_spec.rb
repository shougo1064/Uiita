require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path) }

    let!(:article1) { create(:article, :published, updated_at: 2.days.ago) }
    let!(:article2) { create(:article, :published, updated_at: 1.days.ago) }
    let!(:article3) { create(:article, :published) }
    let!(:article) { create(:article) }
    it "公開状態の記事のみ一覧で取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq 3
      expect(res.map {|article| article["id"] }).to eq [article3.id, article2.id, article1.id]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
      expect(res[0]["status"]).to eq "published"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /api/v1/articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    let(:article_id) { article.id }
    context "公開状態の記事の id を指定したとき" do
      let(:article) { create(:article, :published) }
      it "指定した id の公開記事の詳細が取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
        expect(res["user"].keys).to eq ["id", "name", "email"]
        expect(res["status"]).to eq "published"
      end
    end

    context "下書き状態の記事の id を指定したとき" do
      let(:article) { create(:article, :draft) }
      it "記事の詳細が取得できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "存在しない記事の id を指定したとき" do
      let(:article_id) { 100000 }
      it "指定した id の記事が見つからない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "POST /api/v1/articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    context "下書き状態を指定したとき" do
      let(:params) { { article: attributes_for(:article, :draft) } }
      let(:current_user) { create(:user) }
      let(:headers) { current_user.create_new_auth_token }
      it "下書き記事が作成できる" do
        expect { subject }.to change { Article.count }.by(1)
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
        expect(res["status"]).to eq "draft"
        expect(res["user"]["id"]).to eq current_user.id
        expect(response).to have_http_status(:ok)
      end
    end

    context "公開状態を指定したとき" do
      let(:params) { { article: attributes_for(:article, :published) } }
      let(:current_user) { create(:user) }
      let(:headers) { current_user.create_new_auth_token }
      it "下書き記事が作成できる" do
        expect { subject }.to change { Article.count }.by(1)
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
        expect(res["status"]).to eq "published"
        expect(res["user"]["id"]).to eq current_user.id
        expect(response).to have_http_status(:ok)
      end
    end

    context "不適切なパラメータを送信したとき" do
      let(:params) { attributes_for(:article) }
      let(:current_user) { create(:user) }
      let(:headers) { current_user.create_new_auth_token }
      it "記事の作成に失敗する" do
        expect { subject }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end

  describe "PUT /api/v1/articles/:id" do
    subject { put(api_v1_article_path(article.id), params: params, headers: headers) }

    let(:params) { { article: { title: "foo", created_at: 1.days.ago, status: "published" } } }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }
    context "記事を更新するとき" do
      let!(:article) { create(:article, :draft, user: current_user) }
      it "適切な値のみ更新されている" do
        expect { subject }.to change { article.reload.title }.from(article.title).to(params[:article][:title]) &
                              not_change { article.reload.body } &
                              not_change { article.reload.created_at } &
                              change { article.reload.status }.from(article.status).to(params[:article][:status])
      end
    end
  end

  describe "DELETE /api/v1/articles/:id" do
    subject { delete(api_v1_article_path(article.id), headers: headers) }

    let!(:article) { create(:article, user: current_user) }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    it "記事が削除できる" do
      expect { subject }.to change { Article.count }.by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
