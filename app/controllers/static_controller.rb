class StaticController < ApplicationController
  def index
  end

  def about
    sign_in(:user, User.first) if Rails.env.development?
  end
end
