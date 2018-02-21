class HomeController < ApplicationController
  def index
    @general_status = KeyValuePair.find_by(key: 'general_status')
  end
end
