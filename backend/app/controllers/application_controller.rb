class ApplicationController < ActionController::API
  private

  def current_user
    return @current_user if defined?(@current_user)

    user_id = request.headers["X-User-Id"]
    @current_user = user_id.present? ? User.find_by(id: user_id) : nil
  end

  def authenticate_user!
    return if current_user

    render_unauthorized
  end

  def render_unauthorized
    render json: { errors: [ "Unauthorized" ] }, status: :unauthorized
  end

  def render_forbidden
    render json: { errors: [ "Forbidden" ] }, status: :forbidden
  end
end
