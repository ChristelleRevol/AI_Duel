class VotesController < ApplicationController
  def create
    @battle = Battle.find(params[:battle_id])
    @response = Response.find(params[:response_id])
    @responses = @battle.responses

    if Vote.user_voted?(current_user, @battle)
      redirect_to battle_path(@battle)
      flash[:alert] = "You already voted"
    else
      @vote = Vote.new
      @vote.user = current_user
      @vote.battle = @battle
      @vote.response = @response

      if @vote.save
        redirect_to battle_path(@battle)
        flash[:notice] = "Your vote has been registered"
      else
        render 'battles/show', status: :unprocessable_entity
      end
    end
  end
end
