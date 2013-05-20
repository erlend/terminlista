class Match
  def initialize table_row
    raise 'Invalid match given' unless table_row.is_a? Nokogiri::XML::Element
    @columns = table_row.xpath('./td')
  end

  def home_team
    @columns[3].text
  end

  def away_team
    @columns[5].text
  end

  def teams
    "#{home_team} - #{away_team}"
  end

  def kick_off_at
    DateTime.strptime("#{@columns[0].text[/[\d\.]+/, 0]} #{@columns[2].text}",
                      '%d.%m.%Y %H:%M')
  end

  def result
    return unless played?
    @columns[4].text.gsub(':', '-')
  end

  def played?
    @columns[4].text =~ /\d/
  end

  def unplayed?
    !played?
  end

  def location
    @columns[6].text
  end

  def title
    return teams if unplayed?
    "#{teams} (#{result})"
  end
end
