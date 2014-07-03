require 'yaml'

class Team
  class <<self
    def all
      $all_teams ||= teams_yaml.map do |short, team|
        new(short, team)
      end
    end

    def [] short
      all.find { |team| team.short == short }
    end

    private
    def teams_yaml
      File.open('config/teams.yml') { |file| YAML.load(file) }
    end
  end

  attr_reader :id, :short, :name

  def initialize(short, team)
    @short = short
    @id, @name = team.values_at(:id, :name)
  end

  def url
    "http://www.fotball.no/templates/portal/pages/GenerateICalendar.aspx?teamId=#{id}"
  end
end
