class BattlesController < ApplicationController
  def index
    @battles = Battle.all
    @battles = @battles.where(category: params[:category]) if params[:category].present?
    @battles = @battles.where(model: params[:model]) if params[:model].present?
  end

  def index_ongoing
    @battles = Battle.where(winner: nil)
    render "index_ongoing"
  end

  def show
  end

  def new
    @battle = Battle.new
  end

  def create
    raise
  end

  private

  def battle_params
    params.require(:battle).permit(:category, :end_date, :prompt)
  end
end
