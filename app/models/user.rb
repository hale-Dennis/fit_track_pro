class User < ApplicationRecord

  has_secure_password
  enum :role, { member: 'member', coach: 'coach' }
  has_one_attached :profile_picture

  before_validation :downcase_email

  validates :name, presence: true
  validates :email, presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
  validates :role, presence: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }


  private

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
