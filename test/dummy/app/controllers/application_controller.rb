class ApplicationController < ActionController::Base
  helper Cardboard::ApplicationHelper
  # helper Cardboard::SharedHelper
  protect_from_forgery
end
