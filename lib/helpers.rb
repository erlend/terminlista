module Helpers
  def webcal_for(short_name)
    "#{request.url.sub(/\Ahttps?/, 'webcal')}#{short_name}.ics"
  end

  def track_event(event, properties = nil)
    params = {
      event: event,
      user_id: 'anonymous_user',
      properties: properties,
      context: { userAgent: request.user_agent }
    }
    params.delete(:properties) if params[:properties].nil?

    Analytics.track(params)
  end
end
