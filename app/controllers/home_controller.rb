class HomeController < ApplicationController
  def index
    @general_status = KeyValuePair.find_by(key: 'general_status')
    @estimated_release = KeyValuePair.find_by(key: 'estimated_release')
    @pivotal_data = KeyValuePair.find_by(key: 'pivotal_data')
    @github_data = KeyValuePair.find_by(key: 'github_data')
  end
end
