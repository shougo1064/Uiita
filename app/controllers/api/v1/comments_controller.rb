module Api::V1
  class CommentsController < BaseApiController
    before_action :authenticate_user!, only: [:create]
    def index
      article = Article.published.find(params["comment"]["article_id"])
      comments = article.comments.order(created_at: :desc)
      render json: comments, each_serializer: Api::V1::CommentSerializer
    end

    def create
      Article.published.find(params["comment"]["article_id"])
      comment = current_user.comments.create!(comment_params)
      render json: comment, serializer: Api::V1::CommentSerializer
    end

    private

      def comment_params
        params.require(:comment).permit(:body, :article_id, :created_at)
      end
  end
end
