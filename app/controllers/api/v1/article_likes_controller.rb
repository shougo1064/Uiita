module Api::V1
  class ArticleLikesController < BaseApiController
    before_action :authenticate_user!, only: [:create]

    def create
      Article.find(params["article_like"]["article_id"])
      article_like = current_user.article_likes.create!(article_like_params)
      render json: article_like, serializer: Api::V1::ArticleLikesSerializer
    end

    private

      def article_like_params
        params.require(:article_like).permit(:article_id)
      end
  end
end
