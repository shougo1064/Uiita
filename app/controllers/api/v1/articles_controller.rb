module Api::V1
  class ArticlesController < BaseApiController
    before_action :authenticate_user!, only: [:create, :update, :destroy]
    def index
      articles = Article.published.order(updated_at: :desc)
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      article = Article.published.find(params[:id])
      render json: article, serializer: Api::V1::ArticleSerializer
    end

    def create
      article = current_user.articles.create!(article_params)
      render json: article, serializer: Api::V1::ArticleSerializer
    end

    def update
      article = current_user.articles.find(params[:id])
      article.update!(article_params)
      render json: article, serializer: Api::V1::ArticleSerializer
    end

    def destroy
      article = current_user.articles.find(params[:id])
      article.destroy!
    end

    def search
      # フォームで入力された、キーワードをパラメータで取得
      keyword = params[:keyword]

      # || は、左辺を評価して false だから、右辺を評価した。つまり、渡ってきた sort のパラメータの値が nil の場合、created_at desc をデフォとする。
      sort = params[:sort] || "created_at DESC"

      # 入力された値をLIKE 句により各カラムと一致したものを抽出する。
      articles = Article.published.where("title LIKE(?) or body LIKE(?)", "%#{keyword}%", "%#{keyword}%").order(sort)
      render json: articles, each_serializer: Api::V1::ArticleSerializer
    end

    private

      def article_params
        params.require(:article).permit(:title, :body, :status)
      end
  end
end
