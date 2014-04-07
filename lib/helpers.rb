module Helpers
  def webcal_for(short_name)
    "#{request.url.sub(/\Ahttps?/, 'webcal')}#{short_name}.ics"
  end
end
