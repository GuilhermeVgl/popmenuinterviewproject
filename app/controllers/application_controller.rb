class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  rescue_from ActionController::ParameterMissing, with: :render_bad_request

  rescue_from StandardError, with: :render_internal_server_error

  def not_found
    render json: {
      success: false,
      error: "Route not found",
      details: "No route matches #{request.method} #{request.path}"
    }, status: :not_found
  end

  def render_unprocessable_entity(exception)
    render json: {
      error: "Validation failed",
      details: exception.record.errors.full_messages
    }, status: :unprocessable_entity
  end

  def render_bad_request(exception)
    render json: {
      error: "Bad request",
      details: exception.message
    }, status: :bad_request
  end

  def render_internal_server_error(exception)
    render json: {
      error: "Internal server error",
      details: Rails.env.development? ? exception.message : "An unexpected error occurred"
    }, status: :internal_server_error
  end

  def internal_server_error(exception)
    render json: {
      success: false,
      error: "Internal server error",
      details: exception.message
    }, status: :internal_server_error
  end
end
