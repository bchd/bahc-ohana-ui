class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  scope :admins, -> { where(admin: true) }

  validates :email, presence: true, uniqueness: { case_sensitive: false }

  has_many :favorites

  def admin?
    admin
  end

  # Resets reset password token and sends the account created instructions by email.
  # Returns the token sent in the e-mail.
  def send_account_created_instructions
    token = set_reset_password_token
    send_account_created_instructions_notification(token)

    token
  end

  def send_account_created_instructions_notification(token)
    send_devise_notification(:account_created_instructions, token, {})
  end
end
