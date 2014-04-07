require 'spec_helper'

class HelpersMock
  include Helpers
end

describe Helpers do
  let(:helpers) { HelpersMock.new }

  describe '#webcal_for' do
    before do
      helpers.stub_chain(:request, :url).and_return('http://terminlista.com/')
    end

    it "generates link to the team's ics file" do
      link = helpers.webcal_for('vif')

      expect(link).to match %r{vif\.ics\Z}
    end

    it 'generates link with webcal schema' do
      link = helpers.webcal_for('foo')

      expect(link).to match %r{\Awebcal://}
    end
  end

  describe '#track_event' do
    let(:user_agent) { double 'user agent' }
    before { helpers.stub_chain(:request, :user_agent).and_return(user_agent) }

    it 'reports user agent' do
      expect(Analytics).to receive(:track).
        with(event: 'foo', user_id: 'anonymous_user', context: { userAgent: user_agent })
      helpers.track_event('foo')
    end

    it 'reports event' do
      expect(Analytics).to receive(:track).
        with(event: 'bar', user_id: 'anonymous_user', context: { userAgent: user_agent })
      helpers.track_event('bar')
    end

    it 'reports properties' do
      expect(Analytics).to receive(:track).
        with(event: 'bar', user_id: 'anonymous_user', properties: { team: 'Vålerenga' },
             context: { userAgent: user_agent })
      helpers.track_event('bar', team: 'Vålerenga')
    end
  end
end
