require 'spec_helper'

describe Sinatra::Application do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'GET to /' do
    it 'renders home page' do
      get '/'

      expect(last_response.status).to eq 200
    end
  end

  describe 'GET to /short_name.ics' do
    it 'redirects to calendar' do
      get '/vif.ics'

      expect(last_response.status).to eq 301
      expect(last_response.location).to eq 'http://www.fotball.no/templates/portal/pages/GenerateICalendar.aspx?teamId=277'
    end

    it 'returns 404 for invalid team' do
      get '/foo.ics'

      expect(last_response.status).to eq 404
    end
  end

  describe 'GET to /sitemap.xml' do
    before { get '/sitemap.xml' }

    it 'returns xml file' do
      expect(last_response.content_type).to eq 'text/xml;charset=utf-8'
    end

    it 'returns sitemap' do
      sitemap = Nokogiri::XML(last_response.body)
      urls = sitemap.xpath('//xmlns:url', xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9')
      expect(urls.count).to eq 198
    end
  end
end
