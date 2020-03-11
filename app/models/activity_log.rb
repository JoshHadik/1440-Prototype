# Responsible for modeling an activity that is logged by a user, contains such information as who logged the activity, what the activity was, and when it was started and ended.
class ActivityLog < ApplicationRecord
  belongs_to :user
  validates_presence_of :ended_at, :started_at, :label, :user

  # Check if activity log belongs to owner of activity log.
  def belongs_to?(user)
    self.user == user
  end #TT
end
