class BattlesController < ApplicationController
  def index
    @battles = Battle.all
  end

  def index_ongoing
    @battles = Battle.where(winner: "")
    render "index_ongoing"
  end

  def show
  end

  def new
  end
end
