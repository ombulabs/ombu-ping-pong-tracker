class Match < ActiveRecord::Base
  belongs_to :challenger, class_name: "Player", foreign_key: "challenger_id"
  belongs_to :opponent,   class_name: "Player", foreign_key: "opponent_id"

  def self.by_player(player_id)
    where("challenger_id = :id OR opponent_id = :id", id: player_id)
  end

  # Finds the top challenger and returns it and number of challenges
  #
  # @return [Array] Player and number of challenges
  def self.top_challenger
    top = group(:challenger_id).order("count(matches.id) DESC").count.first
    player = Player.find(top[0])
    [player, top[1]]
  end

  def self.most_played_global
  end

  def self.most_played_against_each_other
    played_against = group(:challenger_id, :opponent_id).count.max_by{|k,v| v }
    pair = [Player.find(played_against[0][0]).username,
            Player.find(played_against[0][1]).username]
    [pair, played_against[1]]
  end
end
