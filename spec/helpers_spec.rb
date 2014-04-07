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
end
