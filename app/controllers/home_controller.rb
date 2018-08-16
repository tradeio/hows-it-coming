class HomeController < ApplicationController
  helper TasksHelper

  def index
    @last_updated = Task.limit(1).order(updated_at: :desc).first.try(:updated_at)
    @tasks_backlog = Task.backlog
    @tasks_in_progress = Task.in_progress
    @tasks_review = Task.review
    @changelog = Task.changelog
    @no_content = Task.count.zero? ? true : false

    # @general_status = KeyValuePair.find_by(key: 'general_status')
    # @estimated_release = KeyValuePair.find_by(key: 'estimated_release')
    # @pivotal_data = KeyValuePair.find_by(key: 'pivotal_data')
    # @github_data = KeyValuePair.find_by(key: 'github_data')

    # total_days = ((Date.parse('June 29, 2018') - Date.parse('January 6, 2018')).to_int)
    # days_left = ((Date.parse('June 29, 2018') - Date.today).to_int)
    # days_passed = total_days - days_left
    # # Another workaround because we don't have ability to integrate with
    # # project management velocity tracking
    # @percent_complete = ( (days_passed.to_f / total_days.to_f) * 100 ).to_i
    # if @percent_complete > 99
    #   @percent_complete = 99
    # end
  end
end
