require 'bundler/setup'
Bundler.require
require_relative 'lib/analytics' unless defined?(Analytics)
require_relative 'lib/team'
require_relative 'lib/helpers'

helpers Helpers

get '/' do
  last_modified File.mtime(File.expand_path('../config/teams.yml', __FILE__))
  @teams = Team.all
  slim :index
end

get '/sitemap.xml' do
  track_event('Get sitemap.xml')
  content_type 'text/xml'
  XmlSitemap::Map.new('terminlista.com') do |m|
    m.add('/', period: :yearly)
    Team.all.each do |team|
      m.add("/#{team.short}.ics", period: :weekly)
    end
  end.render
end

get '/:short_name.?:format?' do |short_name, format|
  @team = if short_name.to_i.to_s == short_name
            # require 'pry'; binding.pry
            Team.new(short_name, id: short_name.to_i)
          else
            Team[short_name]
          end

  if @team
    track_event('Get calendar', team: @team.name)
    redirect @team.url, 301
  else
    raise Sinatra::NotFound
  end
end

__END__
@@ layout
doctype html
html lang='no'
  head
    meta charset='utf-8'
    title Terminlista
    meta name='viewport' content='width=device-width, initial-scale=1.0'
    meta name='description' content='Kalendere for norske fotball-lag'
    meta name='author' content='Erlend Finvåg'
    link rel='stylesheet' href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css"
    /[if lt IE 9]
      script src='http://html5shiv.googlecode.com/svn/trunk/html5.js'
    css:
      .container { max-width: 724px; }
    javascript:
      window.analytics=window.analytics||[],window.analytics.methods=["identify","group","track","page","pageview","alias","ready","on","once","off","trackLink","trackForm","trackClick","trackSubmit"],window.analytics.factory=function(t){return function(){var a=Array.prototype.slice.call(arguments);return a.unshift(t),window.analytics.push(a),window.analytics}};for(var i=0;i<window.analytics.methods.length;i++){var key=window.analytics.methods[i];window.analytics[key]=window.analytics.factory(key)}window.analytics.load=function(t){if(!document.getElementById("analytics-js")){var a=document.createElement("script");a.type="text/javascript",a.id="analytics-js",a.async=!0,a.src=("https:"===document.location.protocol?"https://":"http://")+"cdn.segment.io/analytics.js/v1/"+t+"/analytics.min.js";var n=document.getElementsByTagName("script")[0];n.parentNode.insertBefore(a,n)}},window.analytics.SNIPPET_VERSION="2.0.9",
      window.analytics.load("tqwyaiiet1");
      window.analytics.page();

  body
    a href="https://github.com/erlend/terminlista"
      img[style="position: absolute; top: 0; right: 0; border: 0;"
          src="https://s3.amazonaws.com/github/ribbons/forkme_right_red_aa0000.png"
          alt="Fork me on GitHub"]
    .container
      .page-header : h1
        ' Terminlista
        small Kalendere for norske fotball lag
      == yield

@@ index
table.table.table-bordered.table-striped
  tbody
    - @teams.each do |team|
      tr id="#{team.short}" itemtype='http://schema.org/SportsTeam'
        td itemtprop='name' width='100%' = team.name
        td.text-right
          a.btn.btn-success.btn-xs href=webcal_for(team.short)
            span.glyphicon.glyphicon-calendar
            '
            ' iCal
