class Api::V1::CommentSerializer < ActiveModel::Serializer
  attributes :id, :body
  belongs_to :article, serializer: Api::V1::ArticleSerializer
  belongs_to :user, serializer: Api::V1::UserSerializer
end
