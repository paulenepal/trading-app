class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :first_name, :middle_name, :last_name, :username, :birthday, :confirmed_email, :role, :balance
end
