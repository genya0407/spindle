class Forward < ApplicationRecord
  belongs_to :group

  validates :original_status_uri, presence: true
  validates :json, presence: true
end
