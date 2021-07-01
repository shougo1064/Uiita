class Api::V1::ArticleLikesSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :article, serializer: Api::V1::ArticleSerializer
  belongs_to :user, serializer: Api::V1::UserSerializer
end
