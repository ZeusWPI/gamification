require "rails_helper"

RSpec.describe PublishBounty do

  it "sends a message with Slack" do
    bounty = build :bounty
    expect(Slack).to receive(:send_text)

    PublishBounty.new(bounty).call
  end

  it "generates correct message for bounties with value 1" do
    bounty = build :bounty, value: 1

    expect(Slack).to receive(:send_text) do |text|
      expect(text).to include("1 bountypunt")
    end

    PublishBounty.new(bounty).call
  end

  it "generates correct message for bounties with plural value" do
    bounty = build :bounty, value: 2

    expect(Slack).to receive(:send_text) do |text|
      expect(text).to include("2 bountypunten")
    end

    PublishBounty.new(bounty).call
  end

end
