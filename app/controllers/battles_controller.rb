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

  def history
    @battles = Battle.where.not(winner: nil)

    if params[:filters].present?
      selected_categories = params[:filters].keys
      @battles = @battles.where(category: selected_categories)
    end

    if params[:winners].present?
      selected_winners = params[:winners].keys
      @battles = @battles.where(winner: selected_winners)
    end

    render "history"
  end

  def show
    @battle = Battle.find(params[:id])
    @responses = @battle.responses
    @vote = Vote.find_by(user: current_user, battle: @battle)

    @votes_count_ranking = @responses.map { |response| response.votes.count }.sort_by { |response| -response }

    @ranking = @responses.sort_by { |response| -response.votes.count }.map(&:model)

    @votes_count = 0
    @responses.each { |response| @votes_count += response.votes.count }
  end

  def new
    @battle = Battle.new
  end

  def create
    @battle = Battle.new(battle_params)
    @battle.user = current_user
    if @battle.save
      create_responses(@battle)
      flash[:notice] = "Battle successfully created"
      redirect_to battle_path(@battle)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def battle_params
    params.require(:battle).permit(:category, :end_date, :prompt)
  end

  def create_responses(battle)
    models = ["Claude", "OpenAI", "Mistral"]
    models.shuffle.each do |model|
      Response.create(model: model, battle: battle)
    end
  end
end
