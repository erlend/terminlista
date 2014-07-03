require 'spec_helper'

describe Team do
  let(:team) { Team['vif'] }

  describe 'self.[]' do
    it 'locates team from short name' do
      expect(Team['vif'].id).to eq team.id
    end
  end

  describe 'name' do
    it 'returns name' do
      expect(team.name).to eq 'Vålerenga'
    end
  end

  describe 'url' do
    it 'returns calendar url' do
      expect(team.url).to eq 'http://www.fotball.no/templates/portal/pages/GenerateICalendar.aspx?teamId=277'
    end
  end
end
