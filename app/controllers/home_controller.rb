class HomeController < ApplicationController
  def index
    @general_status = KeyValuePair.find_by(key: 'general_status')
    @estimated_release = KeyValuePair.find_by(key: 'estimated_release')
    @pivotal_data = KeyValuePair.find_by(key: 'pivotal_data')
    @github_data = KeyValuePair.find_by(key: 'github_data')

    total_days = ((Date.parse('June 29, 2018') - Date.parse('January 6, 2018')).to_int)
    days_left = ((Date.parse('June 29, 2018') - Date.today).to_int)
    days_passed = total_days - days_left
    @percent_complete = ( (days_passed.to_f / total_days.to_f) * 100 ).to_i
    if @percent_complete > 99
      @percent_complete = 99
    end
  end
end
