require 'bundler/setup'
Bundler.require
require_relative 'lib/team'

set :cache, Dalli::Client.new

helpers do
  def webcal_for short_name
    "#{request.url.sub(/\ahttps?/, 'webcal')}#{short_name}.ics"
  end
end

get '/' do
  @teams = Team.all
  slim :index
end

get '/sitemap.xml' do
  content_type 'text/xml'
  XmlSitemap::Map.new('terminlista.com') do |m|
    m.add('/', period: :yearly)
    Team.all.each do |team|
      m.add("/#{team.short}.ics", period: :weekly)
    end
  end.render
end

get '/:short_name.?:format?' do |short_name, format|
  @team = Team[short_name]
  if @team
    content_type 'text/calendar'
    @team.to_ical
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
    link rel='stylesheet' href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css"
    /[if lt IE 9]
      script src='http://html5shiv.googlecode.com/svn/trunk/html5.js'
    css:
      .container { max-width: 724px; }
    javascript:
      var _gaq = _gaq || [];
      _gaq.push(['_setAccount', 'UA-23332601-1']);
      _gaq.push(['_setDomainName', 'terminlista.com']);
      _gaq.push(['_trackPageview']);

      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();
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
