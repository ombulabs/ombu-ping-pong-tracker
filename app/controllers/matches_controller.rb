class MatchesController < ApplicationController
  def index
    @matches = Match.joins(:challenger, :opponent)
    @top_challenger, @max_challenges = Match.top_challenger
    @top_pair, @top_pair_played = Match.most_played_against_each_other
  end

  def show
  end
end
