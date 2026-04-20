class ApplicationController < ActionController::API
  private

  # Authentication helpers
  def current_user
    return @current_user if defined?(@current_user)

    user_id = request.headers["X-User-Id"]
    @current_user = user_id.present? ? User.find_by(id: user_id) : nil
  end

  def authenticate_user!
    return if current_user

    render_unauthorized
  end

  # Shared JSON error responses
  def render_bad_request(message)
    render_error(message, :bad_request)
  end

  def render_not_found(message)
    render_error(message, :not_found)
  end

  def render_unprocessable_entity(errors)
    render json: { errors: Array(errors) }, status: :unprocessable_entity
  end

  def render_unauthorized
    render_error("Unauthorized", :unauthorized)
  end

  def render_forbidden
    render_error("Forbidden", :forbidden)
  end

  def render_error(message, status)
    render json: { errors: [ message ] }, status: status
  end
end
