require File.expand_path('../../app', __FILE__)
Bundler.require :test

WebMock.disable_net_connect! allow_localhost: true
