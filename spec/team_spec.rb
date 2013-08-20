require 'spec_helper'

describe Team do
  let(:team) { Team.new 'vif', id: 277 }

  describe 'self.[]' do
    it 'locates team from short name' do
      expect(Team['vif'].id).to eq team.id
    end
  end

  describe 'name' do
    it 'returns name' do
      expect(team.name).to eq 'Vålerenga Menn Senior A'
    end
  end

  describe '#url' do
    it 'returns url' do
      expect(team.url).to eq 'http://www.fotball.no/Community/Lag/Hjem/?fiksId=277'
    end
  end

  describe '#matches' do
    it 'lists all matches' do
      expect(team.matches).to have(33).matches
    end
  end

  describe '#to_ical' do
    let(:calendar) { Icalendar.parse(team.to_ical).first }

    it "has correct name" do
      expect(calendar.properties['x-wr_calname']).to eq 'Vålerenga Menn Senior A terminliste'
    end

    it "has correct timezone" do
      expect(calendar.properties['x-wr_timezone']).to eq 'Europe/Oslo'
    end


    it "has event with correct description" do
      expect(calendar.events.first.description).to eq 'Brann - Vålerenga (3 - 1)'
    end

    it "should have event with correct time" do
      expect(calendar.events.first.dtstart).to eq DateTime.new 2013, 03, 16, 18
      expect(calendar.events.first.dtend).to eq DateTime.new 2013, 03, 16, 20
    end
  end
end
