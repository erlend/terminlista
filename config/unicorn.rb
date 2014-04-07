worker_processes 4
timeout 30
preload_app true

require 'analytics-ruby'

after_fork do |server, worker|
  Analytics = AnalyticsRuby
  Analytics.init({
    secret: 'tqwyaiiet1',
    on_error: Proc.new { |status, msg| print msg }
  })
end
