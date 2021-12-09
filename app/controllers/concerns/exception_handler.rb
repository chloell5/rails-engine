module ExceptionHandler
  extend ActiveSupport::Concern
  
  included do
    rescue_from ActionController::BadRequest do |e|
      render json: { errors: 'Invalid parameters' }, status: 400
    end
  end
end
