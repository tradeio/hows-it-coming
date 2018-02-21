class UpdateGithubDataJob < ApplicationJob
  queue_as :default

  def perform
    github_data = KeyValuePair.find_or_initialize_by(key: 'github_data')

    commits_response = HTTParty.get(
      "https://api.github.com/repos/tradeio/#{ENV['GITHUB_FRONTEND_REPO_NAME']}/commits",
      basic_auth: {
        username: ENV['GITHUB_USERNAME'],
        password: ENV['GITHUB_ACCESS_TOKEN']
      }
    )

    code_frequency_response = get_code_frequency
    unless code_frequency_response.code == 200
      sleep(0.5)
      code_frequency_response = get_code_frequency
      unless code_frequency_response.code == 200
        sleep(5)
        code_frequency_response = get_code_frequency
        unless code_frequency_response == 200
          raise "GitHub API Operation Timed Out or Errored: \n\n#{code_frequency_response}"
        end
      end
    end

    commit_activity_response = get_commit_activity
    unless commit_activity_response.code == 200
      sleep(0.5)
      commit_activity_response = get_commit_activity
      unless commit_activity_response.code == 200
        sleep(5)
        commit_activity_response = get_commit_activity
        unless commit_activity_response == 200
          raise "GitHub API Operation Timed Out or Errored: \n\n#{code_frequency_response}"
        end
      end
    end

    punch_card_response = get_punch_card
    unless punch_card_response.code == 200
      sleep(0.5)
      punch_card_response = get_punch_card
      unless punch_card_response.code == 200
        sleep(5)
        punch_card_response = get_punch_card
        unless punch_card_response == 200
          raise "GitHub API Operation Timed Out or Errored: \n\n#{code_frequency_response}"
        end
      end
    end

    first_five_commits = commits_response.parsed_response[0..4]

    code_frequency_data = code_frequency_response.parsed_response.transpose
    code_frequency_start_at = code_frequency_data.first.shift
    code_frequency_data.delete_at(0)

    commit_activity_data = commit_activity_response.parsed_response
    commit_activity_start_week_index = commit_activity_data.find_index { |e| e['week'] == code_frequency_start_at }
    commit_activity_data = commit_activity_data[commit_activity_start_week_index..-1]

    # Punch Card data is returned in a 2D array of total length 7*24, where
    # each element has a length of three.  The first sub-element in each is the
    # day of the week starting from 0, and the second is the hour of the day
    # starting from 0.  The final number is the actual punch card number, which
    # is what we are interested in.  To make it easier to graph, we are going to
    # delete the day and hour elements (flatten via the :collect method) and
    # then convert the array back into a 2D array of 7 rows of 24 integers.
    punch_card_data = punch_card_response.parsed_response
    punch_card_data_workspace = punch_card_data.collect { |e| e[-1] }
    punch_card_data = []
    while !punch_card_data_workspace.empty?
      punch_card_data << punch_card_data_workspace.slice!(0..23)
    end


    github_data.value = {
      'first_five_commits': first_five_commits.to_json,
      'code_frequency_data': code_frequency_data.to_json,
      'commit_activity_data': commit_activity_data.to_json,
      'punch_card_data': punch_card_data.to_json
    }
    github_data.save
  end

  def get_code_frequency
    HTTParty.get(
      "https://api.github.com/repos/tradeio/#{ENV['GITHUB_FRONTEND_REPO_NAME']}/stats/code_frequency",
      basic_auth: {
        username: ENV['GITHUB_USERNAME'],
        password: ENV['GITHUB_ACCESS_TOKEN']
      }
    )
  end

  def get_commit_activity
    HTTParty.get(
      "https://api.github.com/repos/tradeio/#{ENV['GITHUB_FRONTEND_REPO_NAME']}/stats/commit_activity",
      basic_auth: {
        username: ENV['GITHUB_USERNAME'],
        password: ENV['GITHUB_ACCESS_TOKEN']
      }
    )
  end

  def get_punch_card
    HTTParty.get(
      "https://api.github.com/repos/tradeio/#{ENV['GITHUB_FRONTEND_REPO_NAME']}/stats/punch_card",
      basic_auth: {
        username: ENV['GITHUB_USERNAME'],
        password: ENV['GITHUB_ACCESS_TOKEN']
      }
    )
  end
end
