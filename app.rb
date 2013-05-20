require 'bundler/setup'
Bundler.require
require_relative 'lib/team'

set :cache, Dalli::Client.new

helpers do
  def webcal_for short_name
    "#{request.url.sub(/\ahttps?/, 'webcal')}#{short_name}.ics"
  end
end

get '/' do
  slim :index
end

get '/:short_name.?:format?' do |short_name, format|
  @team = Team[short_name]

  content_type 'text/calendar'
  @team.to_ical
end
