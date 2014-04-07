class Match
  def initialize table_row
    raise 'Invalid match given' unless table_row.is_a? Nokogiri::XML::Element
    @columns = table_row.xpath('./td')
  end

  def home_team
    column_contents(3)
  end

  def away_team
    column_contents(5)
  end

  def teams
    "#{home_team} - #{away_team}"
  end

  def kick_off_at
    DateTime.strptime("#{column_contents(0)[/[\d\.]+/, 0]} #{column_contents(2)}",
                      '%d.%m.%Y %H:%M')
  end

  def result
    return unless played?
    column_contents(4).gsub(':', '-')
  end

  def played?
    column_contents(4) =~ /\d/
  end

  def unplayed?
    !played?
  end

  def location
    column_contents(6)
  end

  def title
    return teams if unplayed?
    "#{teams} (#{result})"
  end

  private
  def column_contents(column_number)
    @columns[column_number].text.strip
  end
end
