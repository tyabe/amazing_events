class Ticket < ActiveRecord::Base

  belongs_to :user
  belongs_to :event

  validates_uniqueness_of :event_id, scope: :user_id
  validates :comment, length: { maximum: 30 }, allow_blank: true
end
