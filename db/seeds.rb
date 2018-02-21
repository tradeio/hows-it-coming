# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

print 'Creating general_status... '
KeyValuePair.find_or_create_by(key: 'general_status') do |general_status|
  general_status.value = {index: 3}
end
puts 'done'

print 'Creating estimated_release... '
KeyValuePair.find_or_create_by(key: 'estimated_release') do |general_status|
  general_status.value = {datetime: DateTime.parse('May 1, 2018, 12:00AM EST'), label: 'Early May'}
end
puts 'done'

print 'Creating pivotal_data... '
UpdatePivotalTrackerDataJob.perform_now
puts 'done'

print 'Creating github_data... '
UpdateGithubDataJob.perform_now
puts 'done'
