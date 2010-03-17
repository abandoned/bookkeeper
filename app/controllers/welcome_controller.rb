class WelcomeController < ApplicationController
  def index
    redirect_to ledger_items_path if current_user
  end
end
