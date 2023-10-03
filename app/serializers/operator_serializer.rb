class OperatorSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :name, :status, :profile, :money, :mobile, :address, :image_id
end
