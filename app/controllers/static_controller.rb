class StaticController < ApplicationController
  def index
  end

  def pricing
  end

  def crash
    raise 'This error is for testing purposes'
  end
end
