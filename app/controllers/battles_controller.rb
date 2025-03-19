class BattlesController < ApplicationController
  def index
    @battles = Battle.all
  end

  def index_ongoing
    @battles = Battle.where(winner: "")
    render "index_ongoing"
  end

  def show
    @battle = Battle.find(params[:id])
    @responses = Response.where(battle: @battle)
  end

  def new
  end
end
