class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :name, :profile, :money, :status, :address, :mobile, :image_id

  # Include any other attributes as needed
end
