Analytics = AnalyticsRuby
Analytics.init({
  secret: 'tqwyaiiet1',
  on_error: Proc.new { |status, msg| print msg }
})

