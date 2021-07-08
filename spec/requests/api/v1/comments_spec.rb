require "rails_helper"

RSpec.describe "Api::V1::Comments", type: :request do
<<<<<<< HEAD
=======

>>>>>>> 3f30c4cde5613a2075ca58343158dfb9a85cdde1
  describe "POST /api/v1/comments" do
    subject { post(api_v1_comments_path, params: params, headers: headers) }

    let(:article) { create(:article) }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }
    context "コメントと記事の id が指定されているとき" do
      let(:params) { { comment: attributes_for(:comment, user: current_user, article_id: article.id) } }
      fit "コメントが投稿できる" do
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
      fit "コメントが投稿できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "記事の id が存在しないとき" do
      let(:params) { { comment: attributes_for(:comment, user: current_user, article_id: nil) } }
      fit "コメントが投稿できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
