class Public::HomesController < ApplicationController
  def top
    @user = User.new
  end
end
