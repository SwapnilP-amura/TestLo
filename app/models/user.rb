class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable, :confirmable

    # validations
    validates :username, uniqueness: true, presence: true,
                         length: { minimum: 4, maximum: 10, message: 'Username should have minimum length between 4-10' },
                         format: { with: /\A[a-zA-Z0-9_.]+\z/, message: 'Allows only alphanumeric characters without spaces' }

    validates :name,
              format: { with: /\A[a-zA-Z\s\.']+\z/, message: 'only allows letters' },
              presence: true,
              length: { maximum: 25, message: 'Name length exceeds limit' }

    validates :phone_no,
              uniqueness: true,
              format: { with: /\A\d+\z/, message: 'Must contain only numbers' },
              length: { minimum: 10, maximum: 15, message: 'Must be 10-15 digits' }
end

# Validation for phone number  to be included
# ^(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}$
