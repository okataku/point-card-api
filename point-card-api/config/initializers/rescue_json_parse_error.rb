Rails.application.config.middleware.insert_before Rack::Head, RescueJsonParseError
