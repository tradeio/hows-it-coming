class UpdatePivotalTrackerDataJob < ApplicationJob
  queue_as :default

  def perform
    pivotal_data = KeyValuePair.find_or_initialize_by(key: 'pivotal_data')

    project_response = HTTParty.get(
      "https://www.pivotaltracker.com/services/v5/projects/#{ENV['PIVOTAL_PROJECT_ID']}",
      headers: {
        'X-TrackerToken' => ENV['PIVOTAL_API_TOKEN']
      }
    )

    history_response = HTTParty.get(
      "https://www.pivotaltracker.com/services/v5/projects/#{ENV['PIVOTAL_PROJECT_ID']}/history/days",
      headers: {
        'X-TrackerToken' => ENV['PIVOTAL_API_TOKEN']
      }
    )

    iterations_response = HTTParty.get(
      "https://www.pivotaltracker.com/services/v5/projects/#{ENV['PIVOTAL_PROJECT_ID']}/iterations",
      headers: {
        'X-TrackerToken' => ENV['PIVOTAL_API_TOKEN']
      }
    )

    headers = history_response.parsed_response['header']
    latest_data = history_response.parsed_response['data'].last

    pivotal_history_data = Hash[headers.zip latest_data]

    stories_per_iteration = iterations_response.parsed_response.map { |e| e['stories'].delete_if { |se| se['accepted_at'].blank? }.length }

    current_points_complete = pivotal_history_data['points_accepted'] + pivotal_history_data['points_delivered'] + pivotal_history_data['points_finished']
    current_points_in_progress = pivotal_history_data['points_started']
    current_points_left = pivotal_history_data['points_planned'] + pivotal_history_data['points_unstarted'] + pivotal_history_data['points_unscheduled']

    current_stories_complete = pivotal_history_data['counts_accepted'] + pivotal_history_data['counts_delivered'] + pivotal_history_data['counts_finished']
    current_stories_in_progress = pivotal_history_data['counts_started']
    current_stories_left = pivotal_history_data['counts_planned'] + pivotal_history_data['counts_unstarted'] + pivotal_history_data['counts_unscheduled']
    current_stories_percent_complete = ((current_stories_complete.to_f / (current_stories_left.to_f + current_stories_in_progress.to_f)) * 100).ceil

    current_points_velocity = current_points_complete / project_response.parsed_response['velocity_averaged_over']

    current_story_velocity = current_stories_complete / project_response.parsed_response['velocity_averaged_over']

    average_points_per_story = current_points_complete / current_stories_complete
    current_story_velocity_alt = current_points_velocity / average_points_per_story

    weeks_to_finish_all_stories = (current_stories_left + current_stories_in_progress) / current_story_velocity
    weeks_to_finish_all_stories_alt = (current_stories_left + current_stories_in_progress) / current_story_velocity_alt

    all_pivotal_data = pivotal_history_data.merge({
      'stories_per_iteration': stories_per_iteration.to_json,
      'current_points_complete': current_points_complete,
      'current_points_in_progress': current_points_in_progress,
      'current_points_left': current_points_left,
      'current_stories_complete': current_stories_complete,
      'current_stories_in_progress': current_stories_in_progress,
      'current_stories_left': current_stories_left,
      'current_stories_percent_complete': current_stories_percent_complete,
      'current_points_velocity': current_points_velocity,
      'current_story_velocity': current_story_velocity,
      'current_story_velocity_alt': current_story_velocity_alt,
      'average_points_per_story': average_points_per_story,
      'weeks_to_finish_all_stories': weeks_to_finish_all_stories,
      'weeks_to_finish_all_stories_alt': weeks_to_finish_all_stories_alt
    })

    pivotal_data.value = all_pivotal_data
    pivotal_data.save
  end
end
