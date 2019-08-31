class RescueJsonParseError
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      @app.call(env)
    rescue ActionDispatch::Http::Parameters::ParseError
      [400, { "Content-Type" => "application/json" }, [{ message: "Invalid JSON format" }.to_json]]
    end
  end
end