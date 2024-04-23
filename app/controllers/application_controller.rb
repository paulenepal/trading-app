class ApplicationController < ActionController::API
  before_action :authenticate_user!
  
  include RackSessionsFix
  respond_to :json
end
