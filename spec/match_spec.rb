require 'spec_helper'

describe Match do
  let(:doc) { Nokogiri::HTML open('spec/fixtures/vif.html') }
  let(:rows) { doc.xpath('//table[@id="tblFixtures"]/tbody/tr') }
  let(:played_match) { Match.new rows.first }
  let(:unplayed_match) { Match.new rows.last }

  describe '#home_team' do
    it 'returns home team name' do
      expect(played_match.home_team).to eq 'Molde'
    end
  end

  describe '#away_team' do
    it 'returns away team name' do
      expect(played_match.away_team).to eq 'Vålerenga'
    end
  end

  describe '#teams' do
    it 'returns team names' do
      expect(played_match.teams).to eq 'Molde - Vålerenga'
    end
  end

  describe '#kick_off_at' do
    it 'returns the match date and time' do
      expect(played_match.kick_off_at).to eq DateTime.new 2014, 03, 28, 19
    end
  end

  describe '#result' do
    it 'returns nil if match is unplayed' do
      expect(unplayed_match.result).to be_nil
    end

    it 'returns result if match is played' do
      expect(played_match.result).to eq '2 - 0'
    end
  end

  describe '#played?' do
    it 'returns false if match is unplayed' do
      expect(unplayed_match).not_to be_played
    end

    it 'returns result if match is played' do
      expect(played_match).to be_played
    end
  end

  describe '#location' do
    it 'returns stadium name' do
      expect(unplayed_match.location).to eq 'Ullevaal Stadion'
    end
  end

  describe '#title' do
    it 'returns teams and result if played' do
      expect(played_match.title).to eq 'Molde - Vålerenga (2 - 0)'
    end

    it 'returns only teams if unplayed' do
      expect(unplayed_match.title).to eq 'Vålerenga - Start'
    end
  end
end
