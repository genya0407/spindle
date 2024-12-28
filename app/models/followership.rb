class Followership < ApplicationRecord
  belongs_to :group
  belongs_to :remote_account
end
