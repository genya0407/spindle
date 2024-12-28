class Forward < ApplicationRecord
  belongs_to :group

  validates :original_status_uri, presence: true

  def actor = group
  def uri = "https://#{Rails.configuration.x.local_domain}/users/#{actor.name}/forwards/#{id}"
end
