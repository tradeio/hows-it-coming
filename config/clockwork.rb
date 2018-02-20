require_relative 'boot'
require_relative 'environment'
require 'clockwork'

module Clockwork
  # every(5.minutes, 'update_crypto_market_caps_job') { UpdateCryptoMarketCapsJob.perform_later }
  #
  # every(1.hour, 'send_incomplete_safte_reminders_job') { SendIncompleteSafteRemindersJob.perform_later }
end
