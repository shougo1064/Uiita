require "rails_helper"

RSpec.describe "Api::V1::ArticleLikes", type: :request do
  describe "POST /api/v1/article_likes" do
    subject { post(api_v1_article_likes_path, params: params, headers: headers) }

    let(:article) { create(:article) }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }
    context "記事の id が存在するとき" do
      let(:params) { { article_like: attributes_for(:article_like, user: current_user, article_id: article.id) } }

      it "いいねできる" do
        expect { subject }.to change { ArticleLike.count }.by(1)
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res["article"]["id"]).to eq params[:article_like][:article_id]
        expect(res["user"]["id"]).to eq current_user.id
      end
    end

    context "記事の id が存在しないとき" do
      let(:params) { { article_like: attributes_for(:article_like, user: current_user, article_id: nil) } }

      it "いいねできない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "DELETE /api/v1/article_likes/:id" do
    subject { delete(api_v1_article_like_path(article_like_id), headers: headers) }

    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }
    context "指定した id が存在するとき" do
      let!(:article_like_id) { article_like.id }
      let!(:article_like) { create(:article_like, user: current_user, article_id: article.id) }
      let(:article) { create(:article) }
      it "いいねを削除できる" do
        expect { subject }.to change { ArticleLike.count }.by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context "指定した id が存在しないとき" do
      let(:article_like_id) { 100_000_000 }
      it "エラーする" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
