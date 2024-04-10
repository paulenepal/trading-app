class ApplicationController < ActionController::API
  include RackSessionsFix
  respond_to :json
end
