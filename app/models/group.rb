class Group < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :followerships
  has_many :following_accounts, through: :followerships, source: :remote_account
end
