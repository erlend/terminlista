require 'spec_helper'

describe Sinatra::Application do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'GET to /' do
    before { get '/' }

    it 'renders home page' do
      expect(last_response.status).to eq 200
    end
  end

  describe 'GET to /short_name.ics' do
    before { get '/vif.ics' }

    it 'returns a calendar' do
      expect(last_response.status).to eq 200
      expect(last_response.content_type).to eq 'text/calendar;charset=utf-8'
    end
  end
end
