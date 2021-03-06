class Task < ApplicationRecord
  default_scope { order(priority: :asc, created_at: :desc) }
  scope :backlog, -> { where(status: :backlog) }
  scope :in_progress, -> { where(status: :in_progress) }
  scope :review, -> { where(status: :review) }
  scope :deployed, -> { where(status: :deployed) }

  enum status: {
    backlog: 0,
    in_progress: 1,
    review: 2,
    deployed: 3
  }

  def self.changelog(limit: nil)
    tasks = self.deployed.order(updated_at: :desc).limit(limit)
    changelog = {}

    tasks.each do |t|
      date = t.updated_at.beginning_of_day
      if (changelog.keys.include?(date))
        changelog[date] << t
      else
        changelog[date] = [t]
      end
    end

    changelog.sort.reverse
  end
end
