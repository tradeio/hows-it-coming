require_relative 'boot'
require_relative 'environment'
require 'clockwork'

module Clockwork
  every(1.day, 'update_pivotal_tracker_data_job', at: '02:00') {
    UpdatePivotalTrackerDataJob.perform_later
  }

  every(1.day, 'update_github_data_job', at: '02:00') {
    UpdateGithubDataJob.perform_later
  }
end
