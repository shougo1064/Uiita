module Api::V1
  class CommentsController < BaseApiController
    before_action :authenticate_user!, only: [:create]
    def create
      article = Article.find(params["comment"]["article_id"])
      comment = current_user.comments.create!(comment_params)
      render json: comment, serializer: Api::V1::CommentSerializer
    end

    private

      def comment_params
        params.require(:comment).permit(:body, :article_id)
      end
  end
end
