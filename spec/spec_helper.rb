require File.expand_path('../../app', __FILE__)
Bundler.require :test

WebMock.disable_net_connect! allow_localhost: true

RSpec.configure do |config|
  config.before do
    stub_request(:get, "www.fotball.no/Community/Lag/Hjem/?fiksId=277").
      to_return status: 200, body: File.new('spec/fixtures/vif.html')
  end
end
