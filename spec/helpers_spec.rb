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
    let(:request_double) { double('request', user_agent: 'foo', ip: '127.0.0.1') }
    let(:default_context) {{ userAgent: 'foo', ip: '127.0.0.1' }}
    before { helpers.stub(:request).and_return(request_double) }

    it 'reports user agent' do
      expect(Analytics).to receive(:track).
        with(event: 'foo', user_id: 'anonymous_user', context: default_context)
      helpers.track_event('foo')
    end

    it 'reports event' do
      expect(Analytics).to receive(:track).
        with(event: 'bar', user_id: 'anonymous_user', context: default_context)
      helpers.track_event('bar')
    end

    it 'reports properties' do
      expect(Analytics).to receive(:track).
        with(event: 'bar', user_id: 'anonymous_user', properties: { team: 'Vålerenga' },
             context: default_context)
      helpers.track_event('bar', team: 'Vålerenga')
    end
  end
end
