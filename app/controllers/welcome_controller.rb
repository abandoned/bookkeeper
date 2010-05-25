class WelcomeController < ApplicationController
  def index
    redirect_to current_user ?
      ledger_items_path : new_user_session_path
  end
end
