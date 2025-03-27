class BattlesController < ApplicationController
  before_action :set_desc_ongoing_battles, only: [:index_ongoing]
  before_action :set_desc_past_battles, only: [:history]

  def index
    @battles = Battle.all
    @past_battles = set_desc_past_battles
    @ongoing_battles = set_desc_ongoing_battles
  end

  def index_ongoing
    if params[:filters].present?
      selected_categories = params[:filters].keys
      @battles = @battles.where(category: selected_categories)
    end

    if params[:winners].present?
      selected_winners = params[:winners].keys
      @battles = @battles.where(winner: selected_winners)
    end
    render "index_ongoing"
  end

  def history
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

    @all_votes_count = {
      "Claude" => Vote.joins(:response).where(responses: { model: "Claude" }).count,
      "OpenAI" => Vote.joins(:response).where(responses: { model: "OpenAI" }).count,
      "Mistral" => Vote.joins(:response).where(responses: { model: "Mistral" }).count
    }
    # Trier par nombre de votes décroissant
    @sorted_votes = @all_votes_count.sort_by { |_, votes| -votes }.to_h
    # Récupérer la liste des modèles triés par nombre de votes
    @sorted_models = @sorted_votes.keys
    # Récupérer la liste des votes triés
    @sorted_vote_counts = @sorted_votes.values
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

  def set_desc_past_battles
    @battles = Battle.where.not(winner: nil).order(created_at: :desc)
  end

  def set_desc_ongoing_battles
    @battles = Battle.where(winner: nil).order(created_at: :desc)
  end
end
