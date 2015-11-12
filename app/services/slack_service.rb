require 'slack'

class SlackService

  attr_reader :client

  def initialize
    @client ||= Slack::Client.new(token: ENV["SLACK_API_TOKEN"])
  end

end
