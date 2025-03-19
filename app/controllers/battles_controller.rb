class BattlesController < ApplicationController
  def index
    @battles = Battle.all
    @battles = @battles.where(category: params[:category]) if params[:category].present?
    @battles = @battles.where(winner: params[:winner]) if params[:winner].present?

    if params[:status].present?
      case params[:status]
      when "nil"
        @battles = @battles.where(winner: nil)
      when "not_nil"
        @battles = @battles.where.not(winner: nil)
      end
    end
  end

  def index_ongoing
    @battles = Battle.where(winner: nil)
    render "index_ongoing"
  end

  def show
  end

  def new
  end
end
