require 'yaml'
require_relative 'match'

class Team
  include Icalendar
  ALL = YAML.load open('config/teams.yml')
  URL = 'http://www.fotball.no/Community/Lag/Hjem/'
  ONE_DAY = 24*60*60

  def self.[] short_name
    new ALL[short_name][:id]
  end

  def initialize id
    @id = id
  end

  def name
    document.at_xpath('//h1').text.strip
  end

  def url
    "http://www.fotball.no/Community/Lag/Hjem/?fiksId=#{@id}"
  end

  def matches
    document.xpath('//table[@id="tblFixtures"]/tbody/tr').map do |match_row|
      Match.new match_row
    end
  end

  def to_ical
    cal = Calendar.new
    timezone = 'Europe/Oslo'
    cal.timezone { timezone_id timezone }
    cal.custom_property 'X-WR-CALNAME;VALUE=TEXT', "#{name} terminliste"
    cal.custom_property 'X-WR-TIMEZONE;VALUE=TEXT', timezone

    matches.each do |match|
      cal.event do
        summary     match.title
        description match.title
        dtstart     match.kick_off_at
        dtend       match.kick_off_at + 2/24.0
        location    match.location
        url         "http://terminlista.com"
      end
    end
    cal.to_ical
  end

  private
  def document
    raise "Could not download page for id #{@id}" if web_page.status != 200
    @document ||= Nokogiri::HTML web_page.body
  end

  def web_page
    @web_page ||= cache.fetch "team:#{@id}:page", ONE_DAY do
      Faraday.get(URL, fiksId: @id)
    end
  end

  def cache
    Sinatra::Application.settings.cache
  end
end
