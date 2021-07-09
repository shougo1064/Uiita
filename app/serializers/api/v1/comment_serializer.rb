class Api::V1::CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at
  belongs_to :article, serializer: Api::V1::ArticleSerializer
  belongs_to :user, serializer: Api::V1::UserSerializer
end
