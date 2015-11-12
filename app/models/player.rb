class Player < ActiveRecord::Base
  has_many :matches_initiated, class_name: "Match", foreign_key: "challenger_id"
  has_many :matches_accepted,  class_name: "Match", foreign_key: "opponent_id"

  def matches
    Match.by_player(id)
  end
end
