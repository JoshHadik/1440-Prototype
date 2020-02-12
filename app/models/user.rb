# Devise generated user model. Most other models and resources can only be accessed in relationship with a specific user object so that the application can be used in relationship with multiple real human users.
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
