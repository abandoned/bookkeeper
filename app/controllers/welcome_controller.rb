class WelcomeController < ApplicationController
  before_filter :require_user
  
  def index
    redirect_to ledger_items_path
  end
end
