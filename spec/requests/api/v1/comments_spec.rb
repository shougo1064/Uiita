require "rails_helper"

RSpec.describe "Api::V1::Comments", type: :request do
  describe "GET /api/v1/comments" do
    subject { get(api_v1_comments_path, params: params) }

    let(:params) { { comment: attributes_for(:comment, article_id: article.id) } }
    let(:article) { create(:article, :published) }
    let!(:comment1) { create(:comment, article_id: article.id, created_at: 1.days.ago) }
    let!(:comment2) { create(:comment, article_id: article.id) }
    it "投稿順にコメントが一覧で取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq 2
      expect(response).to have_http_status(:ok)
      expect(res.map {|comment| comment["id"] }).to eq [comment2.id, comment1.id]
      expect(res[0]["article"]["id"]).to eq params[:comment][:article_id]
      expect(res[0]["article"].keys).to eq ["id", "title", "body", "updated_at", "status"]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
    end
  end

  describe "POST /api/v1/comments" do
    subject { post(api_v1_comments_path, params: params, headers: headers) }

    let(:article) { create(:article, :published) }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }
    context "コメントと記事の id が指定されているとき" do
      let(:params) { { comment: attributes_for(:comment, user: current_user, article_id: article.id) } }
      it "コメントが投稿できる" do
        expect { subject }.to change { Comment.count }.by(1)
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res["body"]).to eq params[:comment][:body]
        expect(res["user"]["id"]).to eq current_user.id
        expect(res["article"]["id"]).to eq params[:comment][:article_id]
      end
    end

    context "コメントが入力されていないとき" do
      let(:params) { { comment: attributes_for(:comment, body: nil, user: current_user, article_id: article.id) } }
      it "コメントが投稿できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "記事の id が存在しないとき" do
      let(:params) { { comment: attributes_for(:comment, user: current_user, article_id: nil) } }
      it "コメントが投稿できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
