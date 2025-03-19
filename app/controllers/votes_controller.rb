class VotesController < ApplicationController
  def create
    @battle = Battle.find(params[:battle_id])
    @response = Response.find(params[:response_id])

    # if Vote.user_voted?(current_user, @battle)
    #   flash[:alert] = "You have already voted"
    # else
      raise
      @vote = Vote.new(vote_params)
      @vote.user = current_user
      @vote.battle = @battle
      @vote.response = @response

      if @vote.save
        redirect_to battle_path(@battle)
      else
        render 'battles/show', status: :unprocessable_entity
      end
    # end
  end

  private

  def vote_params
    params.require(:vote).permit(:user, :battle, :response)
  end
end
