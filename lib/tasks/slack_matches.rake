namespace :slack do
  desc "Populate users from Slack"
  task create_players: :environment do
    list = client.users_list
    list["members"].each do |user|
      unless user["deleted"]
        Player.find_or_create_by(
          user_id: user["id"],
          username: user["name"],
          image_url: user["profile"]["image_72"]
        )
        puts "Found player #{user['name']}!"
      end
    end
  end

  desc "Create matches from Slack messages"
  task create_matches: :environment do
    search_1 = client.search_messages(query: "pong in:general", count: 1000)
    search_2 = client.search_messages(query: "pingpong in:general", count: 1000)
    messages_found_1 = search_1["messages"]["matches"]
    messages_found_2 = search_2["messages"]["matches"]
    messages_found = (messages_found_1 + messages_found_2).uniq
    messages_found.each do |challenger|
      timestamp = Time.at(challenger["ts"].to_i)
      match = Match.find_or_create_by(played_at: timestamp)

      if challenger["text"].length > 80 || !challenger["text"].include?("?")
        match.destroy unless match.new_record?
        next
      end

      player_1 = Player.find_by_username(challenger["username"])
      if player_1.nil?
        match.destroy unless match.new_record?
        next
      end

      match.challenger_id = player_1.id
      match.challenger_message = challenger["text"]

      opponent = challenger["next"]
      if opponent["username"] == "slackbot"
        opponent = challenger["next_2"]
      end

      if opponent["text"].length > 50 || opponent["text"].include?("channel") ||
        opponent["username"] == challenger["username"] ||
        opponent["text"].include?("paso")
        match.destroy unless match.new_record?
        next
      end

      player_2 = Player.find_by_username(opponent["username"])
      if player_2.nil?
        match.destroy unless match.new_record?
        next
      end

      match.opponent_id = player_2.id
      match.opponent_message = opponent["text"]

      match.save!
      puts "Saved #{challenger['username']} vs. #{opponent['username']}!"
    end
  end
end

def client
  SlackService.new.client
end
