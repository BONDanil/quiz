class PagesController < ApplicationController
  def main
    @categories = current_user.categories
  end
end
