module Render
  extend ActiveSupport::Concern

  def no_content()
    render nothing: true,
      status: :no_content,
      body: nil
  end

  def forbidden(model)
    @resource_name = model.to_s.underscore
    render "errors/forbidden",
      status: :forbidden,
      format: "json",
      handler: "jbuilder"
  end
  
  def not_found(model)
    @resource_name = model.to_s.underscore
    render "errors/not_found",
        status: :not_found,
        format: "json",
        handler:"jbuilder"
  end

  def unprocessable_entity(model, errors)
    @resource_name = model.to_s.underscore
    @errors = errors || []
    render "errors/invalid_fields",
        status: :unprocessable_entity,
        format: "json",
        builder: "jbuilder" 
  end
end